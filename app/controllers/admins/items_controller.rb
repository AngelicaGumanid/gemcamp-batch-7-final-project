class Admins::ItemsController < AdminController
  before_action :set_item, only: %i[show edit update destroy start pause end cancel resume]

  require 'csv'
  
  def index
    if params[:show_deleted] == 'true'
      @items = Item.with_deleted.includes(:category).order(created_at: :desc).page(params[:page]).per(10)
    else
      @items = Item.includes(:category).order(created_at: :desc).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate(headers: true) do |csv|
          csv << ["Name", "Quantity", "Minimum Tickets", "Batch Count", "Category", "Status", "State"]
          @items.each do |item|
            csv << [
              item.name,
              item.quantity,
              item.minimum_tickets,
              item.batch_count,
              item.category.try(:name) || 'Uncategorized',
              item.status,
              item.aasm.human_state.capitalize
            ]
          end
        end
        send_data csv_string, filename: "items-#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end

  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admins_items_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admins_items_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def show
    @item = Item.with_deleted.find(params[:id])
  end

  def destroy
    if @item.tickets.any?
      flash[:alert] = "Cannot delete this item because it has associated tickets."
      redirect_to admins_items_path
    else
      @item.destroy
      redirect_to admins_items_path, notice: 'Item successfully deleted.'
    end
  end

  def restore
    @item = Item.with_deleted.find(params[:id])
    @item.update(deleted_at: nil)
    redirect_to admins_items_path, notice: 'Item successfully restored.'
  end

  def start
    if @item.start!
      redirect_to admins_items_path, notice: 'Item successfully started.'
    else
      redirect_to admins_items_path, alert: "Cannot start item. Current state: #{@item.state}"
    end
  end

  def pause
    if @item.pause!
      redirect_to admins_items_path, notice: 'Item successfully paused.'
    else
      redirect_to admins_items_path, alert: 'Cannot pause item.'
    end
  end

  def end
    if @item.end!
      redirect_to admins_items_path, notice: 'Item successfully ended.'
    else
      redirect_to admins_items_path, alert: 'Cannot end item.'
    end
  end

  def cancel
    if @item.cancel!
      redirect_to admins_items_path, notice: 'Item successfully cancelled.'
    else
      redirect_to admins_items_path, alert: 'Cannot cancel item.'
    end
  end

  # def resume
  #   if @item.resume!
  #     redirect_to admins_items_path, notice: 'Item successfully resumed.'
  #   else
  #     redirect_to admins_items_path, alert: 'Cannot resume item.'
  #   end
  # end

  private

  def set_item
    @item = Item.with_deleted.find_by(id: params[:id])

    if @item.nil?
      redirect_to admins_items_path, alert: 'Item not found or has been permanently deleted.'
    end
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :minimum_tickets, :batch_count, :online_at, :offline_at, :start_at, :status, :image, :category_id)
  end

end

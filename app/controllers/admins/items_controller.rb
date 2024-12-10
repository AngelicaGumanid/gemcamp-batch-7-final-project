class Admins::ItemsController < AdminController
  layout 'admin'
  before_action :set_item, only: %i[show edit update destroy start pause end cancel resume]

  def index
    @items = Item.with_deleted.includes(:category)
  end

  def show
    @item = Item.with_deleted.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id]) # Ensure this line is present
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admins_items_path, notice: 'Item successfully created.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to admins_items_path, notice: 'Item successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
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

  def resume
    if @item.resume!
      redirect_to admins_items_path, notice: 'Item successfully resumed.'
    else
      redirect_to admins_items_path, alert: 'Cannot resume item.'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
    redirect_to admins_items_path, alert: 'Item not found.' if @item.nil?
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :minimum_tickets, :batch_count, :online_at, :offline_at, :start_at, :status, :image, :category_id)
  end

end

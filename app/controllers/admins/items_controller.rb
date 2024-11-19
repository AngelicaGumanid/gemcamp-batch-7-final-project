class Admins::ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]


  def index
    @items = Item.all
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
    @item.destroy
    redirect_to admins_items_path, notice: 'Item successfully deleted.'
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
    if @item.nil?
      redirect_to admins_items_path, alert: 'Item not found.' # Redirect to items index page if item is not found
    end
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :minimum_tickets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, :image)
  end

end
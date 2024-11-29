class Admins::OrdersController < AdminController
  before_action :set_order, only: %i[show edit update destroy]

  def index
    @orders = Order.all
    @orders = @orders.where("serial_number LIKE ?", "%#{params[:serial_number]}%") if params[:serial_number].present?
    @orders = @orders.joins(:user).where("users.email LIKE ?", "%#{params[:user_email]}%") if params[:user_email].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where("created_at >= ?", params[:start_date]) if params[:start_date].present?
    @orders = @orders.where("created_at <= ?", params[:end_date]) if params[:end_date].present?
    @orders = @orders.page(params[:page]).per(10)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:user_id, :offer_id, :amount, :coin, :remarks, :genre)
  end
end

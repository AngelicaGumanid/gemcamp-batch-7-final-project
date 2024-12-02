class Admins::OrdersController < AdminController
  before_action :set_order, only: %i[show edit update destroy pay cancel]

  # In your Admins::OrdersController (index action)
  # In your Admins::OrdersController (index action)
  def index
    @orders = Order.all

    @orders = @orders.where("serial_number LIKE ?", "%#{params[:serial_number]}%") if params[:serial_number].present?
    @orders = @orders.joins(:user).where("users.email LIKE ?", "%#{params[:user_email]}%") if params[:user_email].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer_id: params[:offer_id]) if params[:offer_id].present?

    @orders = @orders.where("orders.created_at >= ?", params[:start_date]) if params[:start_date].present?
    @orders = @orders.where("orders.created_at <= ?", params[:end_date]) if params[:end_date].present?

    @subtotal = @orders.sum(:amount)
    @total_coin = @orders.sum(:coin)

    @orders = @orders.page(params[:page]).per(10)

    @total_amount = Order.where("serial_number LIKE ?", "%#{params[:serial_number]}%")
                         .joins(:user)
                         .where("users.email LIKE ?", "%#{params[:user_email]}%")
                         .where(state: params[:state])
                         .where(offer_id: params[:offer_id])
                         .where("orders.created_at >= ?", params[:start_date])
                         .where("orders.created_at <= ?", params[:end_date])
                         .sum(:amount)

    @total_coin = Order.where("serial_number LIKE ?", "%#{params[:serial_number]}%")
                       .joins(:user)
                       .where("users.email LIKE ?", "%#{params[:user_email]}%")
                       .where(state: params[:state])
                       .where(offer_id: params[:offer_id])
                       .where("orders.created_at >= ?", params[:start_date])
                       .where("orders.created_at <= ?", params[:end_date])
                       .sum(:coin)
  end

  # def index
  #   @orders = Order.all
  #
  #   @orders = @orders.where("serial_number LIKE ?", "%#{params[:serial_number]}%") if params[:serial_number].present?
  #   @orders = @orders.joins(:user).where("users.email LIKE ?", "%#{params[:user_email]}%") if params[:user_email].present?
  #   @orders = @orders.where(state: params[:state]) if params[:state].present?
  #   @orders = @orders.where(offer_id: params[:offer_id]) if params[:offer_id].present?
  #   @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
  #   @orders = @orders.where("created_at >= ?", params[:start_date]) if params[:start_date].present?
  #   @orders = @orders.where("created_at <= ?", params[:end_date]) if params[:end_date].present?
  #
  #   @orders = @orders.page(params[:page]).per(10)
  #
  #   @subtotal = @orders.sum(:amount)
  #   @total = @orders.sum(:coin)
  # end

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

  def pay
    if @order && @order.can_pay?
      @order.pay!
      redirect_to admins_orders_path, notice: 'Order was successfully paid.'
    else
      redirect_to admins_orders_path, alert: 'Order cannot be paid.'
    end
  end

  def cancel
    if @order && @order.can_cancel?
      @order.cancel!
      redirect_to admins_orders_path, notice: 'Order was successfully canceled.'
    else
      redirect_to admins_orders_path, alert: 'Order cannot be canceled.'
    end
  end

  private

  def set_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      redirect_to admins_orders_path, alert: 'Order not found.'
    end
  end

  def order_params
    params.require(:order).permit(:user_id, :offer_id, :amount, :coin, :remarks, :genre)
  end
end

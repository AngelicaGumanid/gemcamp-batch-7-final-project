class Admins::OrdersController < AdminController
  before_action :set_order, only: %i[show edit update destroy pay cancel]

  def index
    @orders = Order.all.order(created_at: :desc)

    @orders = @orders.filter_by_serial(params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.filter_by_user_email(params[:user_email]) if params[:user_email].present?
    @orders = @orders.filter_by_state(params[:state]) if params[:state].present?
    @orders = @orders.filter_by_offer(params[:offer_id]) if params[:offer_id].present?
    @orders = @orders.filter_by_date_range(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?

    @subtotal = @orders.sum(:amount)
    @subtotal_coin = @orders.sum(:coin)

    @total_amount = @orders.sum(:amount)
    @total_coins_from_all = @orders.sum(:coin)

    @orders = @orders.page(params[:page]).per(10)
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

  def submit
    @order = Order.find(params[:id])
    if @order.may_submit?
      @order.submit!
      redirect_to admins_orders_path, notice: "Order submitted successfully."
    else
      redirect_to admins_orders_path, alert: "Order cannot be submitted."
    end
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

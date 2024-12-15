class Admins::BalanceOperateController < AdminController
  before_action :set_user, only: [:show, :edit, :increase]

  def increase
    @increase = Order.new(user: @user, amount: 0, coin: params[:coin], genre: "increase", remarks: params[:remarks])
    if @increase.save
      @increase.submit!
      @increase.pay!
      redirect_to admins_user_increase_path, notice: 'Increase successfully added to the user.'
    else
      flash[:alert] = @increase.errors.full_messages.to_sentence
      redirect_to admins_user_increase_path(@user)
    end
  end


  def new
    @user = User.find(params[:user_id])
    @order = Order.find(params[:order_id])
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "User not found"
    redirect_to admins_users_path
  end
end
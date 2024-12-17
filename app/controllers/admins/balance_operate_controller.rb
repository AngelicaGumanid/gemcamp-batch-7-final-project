class Admins::BalanceOperateController < AdminController
  before_action :set_user, only: [:increase, :deduct, :bonus, :share_bonus]

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

  def deduct
    @deduct = Order.new(user: @user, amount: 0, coin: params[:coin], genre: "deduct", remarks: params[:remarks])
    if @deduct.save
      @deduct.submit!
      @deduct.pay!
      redirect_to admins_user_increase_path, notice: 'Deduction successfully processed.'
    else
      flash[:alert] = @deduct.errors.full_messages.to_sentence
      redirect_to admins_user_increase_path(@user)
    end
  end

  def bonus
    @bonus = Order.new(user: @user, amount: params[:amount], coin: params[:coin], genre: "bonus", remarks: params[:remarks])
    if @bonus.save
      @bonus.submit!
      @bonus.pay!
      redirect_to admins_user_bonus_path(@user), notice: 'Bonus successfully added to the user.'
    else
      flash[:alert] = @bonus.errors.full_messages.to_sentence
      redirect_to admins_user_bonus_path(@user)
    end
  end

  def share_bonus
    @share_bonus = Order.new(user: @user, amount: params[:amount], coin: params[:coin], genre: "share", remarks: params[:remarks])
    if @share_bonus.save
      @share_bonus.submit!
      @share_bonus.pay!
      redirect_to admins_user_share_bonus_path(@user), notice: 'Share bonus successfully added to the user.'
    else
      flash[:alert] = @share_bonus.errors.full_messages.to_sentence
      redirect_to admins_user_share_bonus_path(@user)
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
class Clients::ProfilesController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!

  def show
    @user = current_clients_user
    @user = current_clients_user
    @orders = @user.orders.includes(:offer).order(created_at: :desc).page(params[:page]).per(10)
    @lotteries = @user.tickets.includes(:item).order(created_at: :desc).page(params[:page]).per(10)
    @invites = User.where(parent_id: @user.id).order(created_at: :desc).page(params[:page]).per(10)
    @winnings = Winner.includes(:item, :ticket).where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    @user = current_clients_user
    @disable_popup_message = true
  end

  def update
    @user = current_clients_user
    @disable_popup_message = true

    if params[:user][:current_password].blank?
      flash.now[:alert] = 'Failed to update profile. Current password is required.'
      @user.errors.add(:current_password, 'is required to update your profile')
      render :edit
    else
      if @user.valid_password?(params[:user][:current_password])
        update_params = profile_params.except(:current_password)
        update_params.delete(:password) if update_params[:password].blank?

        if @user.update(update_params)
          flash[:notice] = 'Profile updated successfully.'
          redirect_to clients_profiles_path
        else
          flash.now[:alert] = 'Failed to update profile.'
          render :edit
        end
      else
        flash.now[:alert] = 'Failed to update profile. Current password is incorrect.'
        @user.errors.add(:current_password, 'is incorrect')
        render :edit
      end
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :email, :phone, :password, :current_password, :image)
  end

end

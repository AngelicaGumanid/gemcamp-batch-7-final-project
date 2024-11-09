class Clients::ProfilesController < ApplicationController
  before_action :authenticate_clients_user!

  def show
    @user = current_clients_user
  end

  def edit
    @user = current_clients_user
  end

  def update
    @user = current_clients_user

    if profile_params[:password].present?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(profile_params.except(:current_password))
          redirect_to clients_profile_path, notice: 'Profile updated successfully.'
        else
          render :edit, alert: 'Failed to update profile.'
        end
      else
        @user.errors.add(:current_password, 'is incorrect')
        render :edit, alert: 'Failed to update profile. Current password is incorrect.'
      end
    else
      if @user.update(profile_params.except(:current_password, :password))
        redirect_to clients_profile_path, notice: 'Profile updated successfully.'
      else
        render :edit, alert: 'Failed to update profile.'
      end
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :email, :phone, :password, :current_password, :image)
  end

end

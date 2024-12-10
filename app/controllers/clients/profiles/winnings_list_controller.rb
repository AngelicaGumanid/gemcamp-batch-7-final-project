class Clients::Profiles::WinningsListController < ApplicationController
  layout 'client'
  before_action :set_winner, only: [:edit, :update, :share_form, :share]

  def index
    @winnings = current_clients_user.winners.includes(:item).order(created_at: :desc).page(params[:page]).per(5)
  end

  def edit
    @locations = current_clients_user.locations
    @default_location = @locations.find_by(is_default: true) || @locations.first
  end

  def update
    if @winner.update(winner_params)
      @winner.claim!
      redirect_to clients_profiles_path(anchor: "winning-history"), notice: 'Prize claimed successfully!'
    else
      flash.now[:alert] = 'Failed to claim the prize. Please try again.'
      render :edit
    end
  end

  def share_form
    @winner = current_clients_user.winners.find(params[:id])
  end

  def share
    if @winner.update(winner_share_params)
      if @winner.may_share?
        @winner.share!
        redirect_to clients_profiles_path(anchor: "winning-history"), notice: 'Your prize has been shared successfully!'
      else
        flash.now[:alert] = 'Invalid state transition.'
        render :share_form
      end
    else
      flash.now[:alert] = @winner.errors.full_messages.join(', ')
      render :share_form
    end
  end

  private

  def set_winner
    @winner = current_clients_user.winners.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:location_id)
  end

  def winner_share_params
    params.require(:winner).permit(:picture, :comment)
  end
end
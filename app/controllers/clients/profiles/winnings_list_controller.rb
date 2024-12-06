class Clients::Profiles::WinningsListController < ApplicationController
  layout 'client'
  before_action :set_winner, only: [:edit, :update]

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

  private

  def set_winner
    @winner = current_clients_user.winners.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:location_id)
  end
end

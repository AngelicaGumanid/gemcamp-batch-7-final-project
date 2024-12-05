class Clients::Profiles::WinningsListController < ApplicationController
  layout 'client'

  def index
    @winnings = current_clients_user.winners.includes(:item).order(created_at: :desc).page(params[:page]).per(5)
  end
end

class Clients::Profiles::WinningsListController < ApplicationController
  layout 'client'

  def index
    @winnings = Winner.where(user: current_clients_user).page(params[:page]).per(5)
  end
end

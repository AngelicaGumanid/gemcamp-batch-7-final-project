class Clients::Profiles::OrderHistoryController < ApplicationController
  layout 'client'

  def index
    @orders = current_clients_user.orders.includes(:offer).order(created_at: :desc).page(params[:page]).per(10)
  end
end

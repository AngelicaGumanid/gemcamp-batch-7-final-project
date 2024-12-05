class Clients::Profiles::OrderHistoryController < ApplicationController
  layout 'client'

  def index
    @orders = current_clients_user.orders.order(created_at: :desc).page(params[:page]).per(5)
  end
end

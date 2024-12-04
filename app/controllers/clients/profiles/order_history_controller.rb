class Clients::Profiles::OrderHistoryController < ApplicationController
  layout 'client'

  def index
    @orders = Order.where(user: current_clients_user).page(params[:page]).per(5)
  end
end

class Clients::SharesController < ApplicationController
  layout 'client'

  # Skip authentication to allow public access
  before_action :authenticate_clients_user!, except: [:index, :show]

  def index
    @shares = Winner.where(state: 'published').includes(:item, :user)
  end

  def show
    @share = Winner.find_by(id: params[:id], state: 'published')
    redirect_to clients_shares_path, alert: 'Share not found' unless @share
  end
end
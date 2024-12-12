class Clients::SharesController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!, except: [:index, :show]

  def index
    @shares = Winner.where(state: 'published').includes(:item, :user)

    @banners = Banner.where(status: :active, online_at: ..Time.now, offline_at: Time.now..)
    @news_tickers = NewsTicker.active.limit(5)
  end

  def show
    @share = Winner.find_by(id: params[:id], state: 'published')
    redirect_to clients_shares_path, alert: 'Share not found' unless @share
  end
end
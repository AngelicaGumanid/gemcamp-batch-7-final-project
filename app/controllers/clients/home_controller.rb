class Clients::HomeController < ApplicationController
  layout 'client'
  def index
    @items = Item.where("online_at <= ? AND offline_at >= ? AND status = ? AND state = ?",
                        Time.current, Time.current, 1, 'starting')
                 .includes(:category)

    @categories = Category.all

    @banners = Banner.where(status: :active, online_at: ..Time.now, offline_at: Time.now..)
    @news_tickers = NewsTicker.active.limit(5)
    @winners = Winner.where.not(picture: nil).includes(:user).limit(5)
    @items = Item.where(status: :active, state: :starting).limit(8)

  end
end

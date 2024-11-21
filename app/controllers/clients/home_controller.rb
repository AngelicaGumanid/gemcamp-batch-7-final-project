class Clients::HomeController < ApplicationController
  layout 'client'
  def index
    @items = Item.where("online_at <= ? AND offline_at >= ? AND status = ? AND state = ?",
                        Time.current, Time.current, 1, 'starting')
                 .includes(:category)

    @categories = Category.all
  end
end

class Clients::SharesController < ApplicationController
  layout 'client'

  def index
    @shares = Item.where(state: 'published')
  end

  def show
    @share = Item.find(params[:id])
  end
end

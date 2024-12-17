class Clients::ShopsController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!, except: [:index, :show]
  before_action :set_offer, only: [:show, :purchase]

  def index
    @offers = Offer.active

    @banners = Banner.where(status: :active, online_at: ..Time.now, offline_at: Time.now..)
    @news_tickers = NewsTicker.active.limit(5)
  end

  def show
    unless @offer.active?
      redirect_to clients_shops_path, alert: "Offer is no longer available for purchase."
      return
    end
  end

  def purchase
    purchase_quantity = params[:quantity].to_i

    if purchase_quantity <= 0
      redirect_to clients_shop_path(@offer), alert: "Invalid purchase quantity."
      return
    end

    ActiveRecord::Base.transaction do
      purchase_quantity.times do
        current_clients_user.orders.create!(
          offer: @offer,
          genre: :deposit,
          coin: @offer.coin,
          amount: @offer.amount,
          state: :pending
        )
      end
    end

    redirect_to clients_shop_path(@offer), notice: "#{purchase_quantity} offer(s) purchased successfully."

  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end
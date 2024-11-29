class Clients::OrdersController < ApplicationController
  before_action :authenticate_clients_user!

  def create
    offer = Offer.find(params[:offer_id])

    if offer.active?
      order = current_clients_user.orders.new(offer: offer, state: :pending, amount: offer.amount, coin: offer.coin)
      if order.save
        order.submit!
        redirect_to clients_profile_path, notice: 'Order created successfully!'
      else
        redirect_to clients_shops_path, alert: 'Failed to create order.'
      end
    else
      redirect_to clients_shops_path, alert: 'Offer is no longer available.'
    end
  end
end

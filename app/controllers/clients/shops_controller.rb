class Clients::ShopsController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!, except: [:index, :show]
  before_action :set_offer, only: [:show, :purchase]

  def index
    @offers = Offer.active
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

    total_cost = @offer.coin * purchase_quantity

    if current_clients_user.coins >= total_cost
      ActiveRecord::Base.transaction do
        current_clients_user.decrement!(:coins, total_cost)

        purchase_quantity.times do |i|
          order = current_clients_user.orders.create!(
            offer: @offer,
            genre: :deduct,
            coin: @offer.coin,
            amount: @offer.amount,
            state: :pending
          )

          if order.persisted?
            order.submit!
          else
            raise ActiveRecord::Rollback, "Order #{i + 1} failed: #{order.errors.full_messages.join(', ')}"
          end
        end
      end

      redirect_to clients_shop_path(@offer), notice: "#{purchase_quantity} offer(s) purchased successfully."
    else
      redirect_to clients_shop_path(@offer), alert: "You do not have enough coins."
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end
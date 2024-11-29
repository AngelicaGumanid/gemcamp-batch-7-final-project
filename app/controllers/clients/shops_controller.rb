class Clients::ShopsController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!, except: [:index]
  before_action :set_offer, only: [:show]

  def index
    @offers = Offer.active
    @categories = Category.includes(:items)
  end

  def show; end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  # def purchase
  #   redirect_to new_user_session_path, alert: 'Please sign in to purchase.' unless user_signed_in?
  # end
end

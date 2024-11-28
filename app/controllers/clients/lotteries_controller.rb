class Clients::LotteriesController < ApplicationController
  layout 'client'

  skip_before_action :authenticate_user!, only: :index

  def index
    @categories = Category.includes(:items)
    items_scope = Item.where(status: :active, state: :starting)
                      .where("offline_at IS NULL OR offline_at > ?", Time.current)

    if params[:category].present?
      @items = items_scope.where(category_id: params[:category])
      Rails.logger.debug "Filtering by category: #{params[:category]}"
    else
      @items = items_scope
      Rails.logger.debug "No category filter applied"
    end
  end

end

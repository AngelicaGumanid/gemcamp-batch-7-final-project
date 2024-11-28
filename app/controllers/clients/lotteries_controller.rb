class Clients::LotteriesController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :buy_ticket]

  def index
    @categories = Category.includes(:items)
    items_scope = Item.where(status: :active, state: :starting)
                      .where("offline_at IS NULL OR offline_at > ?", Time.current)

    if params[:category].present?
      @items = items_scope.where(category_id: params[:category])
      # Rails.logger.debug "Filtering by category: #{params[:category]}"
    else
      @items = items_scope
      # Rails.logger.debug "No category filter applied"
    end
  end

  def show
    @item = Item.find(params[:id])

    redirect_to root_path, alert: "Item is not available for purchase" unless @item.state == "starting"

    @user_tickets = @item.tickets.where(user: current_clients_user)
    @ticket_count = @user_tickets.count
  end

  def buy_ticket
    ticket_count = params[:ticket_count].to_i

    if ticket_count <= 0
      redirect_to clients_lottery_path(@item), alert: "Invalid ticket count."
      return
    end

    if current_clients_user.coins >= ticket_count
      current_clients_user.decrement!(:coins, ticket_count)

      Ticket.transaction do
        ticket_count.times do |i|
          ticket = current_clients_user.tickets.create(item: @item, batch_count: @item.batch_count)
          unless ticket.persisted?
            raise ActiveRecord::Rollback, "Ticket #{i + 1} failed: #{ticket.errors.full_messages.join(', ')}"
          end
        end
      end

      redirect_to clients_lottery_path(@item), notice: "#{ticket_count} ticket(s) purchased successfully."
    else
      redirect_to clients_lottery_path(@item), alert: "You do not have enough coins."
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

end

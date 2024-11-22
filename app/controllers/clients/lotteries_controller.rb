class Clients::LotteriesController < ApplicationController
  before_action :set_item, only: [:buy_ticket]
  before_action :authenticate_user!, only: [:buy_ticket]

  def index
    @items = Item.active
    @user_tickets = current_clients_user&.tickets || []
  end

  def buy_ticket
    unless @item.starting?
      redirect_to lotteries_path, alert: "This item is not available for ticket purchase."
      return
    end

    ticket_count = params[:ticket_count].to_i
    if current_user.coins < ticket_count
      redirect_to lotteries_path, alert: "Insufficient coins to purchase tickets."
      return
    end

    Ticket.transaction do
      ticket_count.times do
        Ticket.create!(user: current_user, item: @item, state: "pending")
      end
      current_user.decrement!(:coins, ticket_count)
    end

    redirect_to lotteries_path, notice: "#{ticket_count} ticket(s) purchased successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to lotteries_path, alert: "Failed to purchase tickets: #{e.message}"
  end

  private

  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to lotteries_path, alert: "Item not found."
  end
end

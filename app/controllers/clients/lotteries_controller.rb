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
    else
      @items = items_scope
    end

    @banners = Banner.where(status: :active, online_at: ..Time.now, offline_at: Time.now..)
    @news_tickers = NewsTicker.active.limit(5)
  end

  def show
    @item = Item.find(params[:id])

    redirect_to root_path, alert: "Item is not available for purchase" unless @item.state == "starting"

    @user_tickets = @item.tickets.where(user: current_clients_user).page(params[:page]).per(10)
    @ticket_count = @user_tickets.count
  end


  def buy_ticket
    ticket_count = params[:ticket_count].to_i

    if current_clients_user.coins < ticket_count
      redirect_to clients_lotteries_path, alert: "You do not have enough coins. Please top up."
      return
    end

    if ticket_count <= 0
      redirect_to clients_lottery_path(@item), alert: "Invalid ticket count."
      return
    end

    Ticket.transaction do
      Ticket.deduct_coins_for_tickets(current_clients_user, ticket_count)

      ticket_count.times do |i|
        ticket = current_clients_user.tickets.create(item: @item, batch_count: @item.batch_count)
        unless ticket.persisted?
          raise ActiveRecord::Rollback, "Ticket #{i + 1} failed: #{ticket.errors.full_messages.join(', ')}"
        end
      end
    end

    redirect_to clients_lottery_path(@item), notice: "#{ticket_count} ticket(s) purchased successfully."
  rescue ActiveRecord::Rollback
    redirect_to clients_lottery_path(@item), alert: "Ticket purchase failed, please try again."
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end

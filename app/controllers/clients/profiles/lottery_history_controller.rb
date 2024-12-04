class Clients::Profiles::LotteryHistoryController < ApplicationController
  layout 'client'

  def index
    @lotteries = Ticket.includes(:item).where(user: current_clients_user).page(params[:page]).per(5)
  end
end

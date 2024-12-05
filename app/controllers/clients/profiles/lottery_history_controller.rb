class Clients::Profiles::LotteryHistoryController < ApplicationController
  layout 'client'

  def index
    @lotteries = current_clients_user.tickets.includes(:item).order(created_at: :desc).page(params[:page]).per(10)
  end
end

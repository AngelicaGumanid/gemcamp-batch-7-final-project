class Admins::WinnersController < AdminController
  layout 'admin'
  before_action :set_winner, only: %i[show edit update destroy submit pay ship deliver publish remove_publish]

  def index
    @winners = Winner.joins(:ticket, :user)
                     .includes(:item, :ticket, :user, :admin)
                     .where(*search_conditions)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def submit
    if @winner.won?
      @winner.claim!
      flash[:notice] = "Winner #{@winner.ticket.serial_number} has been claimed."
    else
      flash[:alert] = "Cannot claim winner."
    end
    redirect_to admins_winners_path
  end

  def pay
    if @winner.claimed?
      @winner.submit!
      flash[:notice] = "Winner #{@winner.ticket.serial_number} has been submitted."
    else
      flash[:alert] = "Cannot submit winner."
    end
    redirect_to admins_winners_path
  end

  def ship
    if @winner.submitted?
      @winner.pay!
      flash[:notice] = "Winner #{@winner.ticket.serial_number} has been paid."
    else
      flash[:alert] = "Cannot mark winner as paid."
    end
    redirect_to admins_winners_path
  end

  def deliver
    if @winner.paid?
      @winner.ship!
      flash[:notice] = "Winner #{@winner.ticket.serial_number} has been shipped."
    else
      flash[:alert] = "Cannot mark winner as shipped."
    end
    redirect_to admins_winners_path
  end

  def publish
    if @winner.delivered?
      @winner.share!
      flash[:notice] = "Winner #{@winner.ticket.serial_number} has been shared."
    else
      flash[:alert] = "Cannot share winner."
    end
    redirect_to admins_winners_path
  end

  def remove_publish
    if @winner.published?
      @winner.remove_publish!
      flash[:notice] = "Winner #{@winner.ticket.serial_number} has been removed from published."
    else
      flash[:alert] = "Cannot remove published winner."
    end
    redirect_to admins_winners_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def search_conditions
    conditions = []
    values = {}

    if params[:serial_number].present?
      conditions << "tickets.serial_number LIKE :serial_number"
      values[:serial_number] = "%#{params[:serial_number]}%"
    end

    if params[:email].present?
      conditions << "users.email LIKE :email"
      values[:email] = "%#{params[:email]}%"
    end

    if params[:state].present? && params[:state] != 'all'
      conditions << "winners.state = :state"
      values[:state] = params[:state]
    end

    if params[:start_date].present? && params[:end_date].present?
      conditions << "winners.created_at BETWEEN :start_date AND :end_date"
      values[:start_date] = params[:start_date].to_date.beginning_of_day
      values[:end_date] = params[:end_date].to_date.end_of_day
    end

    [conditions.any? ? conditions.join(" AND ") : "1=1", values]
  end

end

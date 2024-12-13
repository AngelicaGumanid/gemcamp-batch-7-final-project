class Admins::WinnersController < AdminController
  layout 'admin'
  before_action :set_winner, only: [:edit, :update, :show, :destroy, :submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.joins(:ticket, :user)
                     .includes(:item, :ticket, :user, :admin)
                     .where(*search_conditions)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  def submit
    transition_state(@winner, :claim, 'claimed')
  end

  def pay
    transition_state(@winner, :submit, 'submitted')
  end

  def ship
    transition_state(@winner, :pay, 'paid')
  end

  def deliver
    transition_state(@winner, :deliver, 'delivered')
  end

  def publish
    transition_state(@winner, :publish, 'shared')
  end

  def remove_publish
    transition_state(@winner, :remove_publish, 'removed from published')
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def transition_state(winner, event, success_state)
    Rails.logger.info "Current state: #{winner.aasm.current_state}"
    if winner.send("#{event}!")
      flash[:notice] = "Winner #{winner.ticket.serial_number} has been #{success_state}."
    else
      flash[:alert] = "Cannot mark winner as #{success_state}."
    end
    redirect_to admins_winners_path
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

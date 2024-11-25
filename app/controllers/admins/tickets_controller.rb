class Admins::TicketsController < AdminController
  layout 'admin'
  before_action :set_ticket, only: %i[show cancel]

  def index
    conditions, values = search_conditions
    Rails.logger.debug "Conditions: #{conditions}, Values: #{values}"

    if conditions.blank?
      @tickets = Ticket.joins(:item, :user)
                       .order(created_at: :desc)
                       .page(params[:page])
                       .per(20)
    else
      @tickets = Ticket.joins(:item, :user)
                       .where(conditions, values)
                       .order(created_at: :desc)
                       .page(params[:page])
                       .per(20)
    end

    Rails.logger.debug @tickets.to_sql
  end

  def cancel
    if @ticket.pending?
      @ticket.cancel!
      flash[:notice] = "Ticket #{@ticket.serial_number} has been cancelled and coin refunded."
    else
      flash[:alert] = 'Ticket cannot be cancelled.'
    end
    redirect_to admins_tickets_path
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def search_conditions
    conditions = []
    values = {}

    if params[:serial_number].present?
      conditions << "tickets.serial_number LIKE :serial_number"
      values[:serial_number] = "%#{params[:serial_number]}%"
    end

    if params[:item_name].present?
      conditions << "items.name LIKE :item_name"
      values[:item_name] = "%#{params[:item_name]}%"
    end

    if params[:email].present?
      conditions << "users.email LIKE :email"
      values[:email] = "%#{params[:email]}%"
    end

    if params[:state].present?
      conditions << "tickets.state = :state"
      values[:state] = params[:state]
    end

    if params[:start_date].present? && params[:end_date].present?
      conditions << "tickets.created_at BETWEEN :start_date AND :end_date"
      values[:start_date] = params[:start_date].to_date.beginning_of_day
      values[:end_date] = params[:end_date].to_date.end_of_day
    end

    [conditions.join(" AND "), values]
  end
end

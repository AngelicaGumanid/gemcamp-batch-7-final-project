class Admins::TicketsController < AdminController
  before_action :set_ticket, only: %i[show cancel]

  require 'csv'

  def index
    @tickets = Ticket.joins(:item, :user)
                     .includes(:item, :user)
                     .where(*search_conditions)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate(headers: true) do |csv|
          csv << ["Serial Number", "Item Name", "Email", "State", "Created At"]
          @tickets.each do |ticket|
            csv << [
              ticket.serial_number,
              ticket.item_name,
              ticket.user.email,
              ticket.state,
              ticket.created_at.strftime('%Y-%m-%d %H:%M:%S')
            ]
          end
        end
        send_data csv_string, filename: "tickets-#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end

  end

  def cancel
    if @ticket.pending?
      if @ticket.cancel!
        flash[:notice] = "Ticket #{@ticket.serial_number} has been cancelled, and coins have been refunded."
      else
        flash[:alert] = 'Failed to cancel the ticket.'
      end
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

    [conditions.any? ? conditions.join(" AND ") : "1=1", values]
  end
end

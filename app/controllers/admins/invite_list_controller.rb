class Admins::InviteListController < AdminController

  require 'csv'

  def index
    @users = User.includes(:parent, :children)
                 .where.not(parent_id: nil)
                 .order(created_at: :desc)

    if params[:parent_email].present?
      @users = @users.joins("INNER JOIN users parents ON parents.id = users.parent_id")
                     .where("LOWER(parents.email) LIKE LOWER(?)", "%#{params[:parent_email]}%")
    end

    @users = @users.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate(headers: true) do |csv|
          csv << ["Parent Email", "Email", "Total Deposit", "Members Total Deposit", "Coins", "Created At", "Coins Used Count", "Child Members"]
          @users.each do |user|
            csv << [
              user.parent.try(:email),
              user.email,
              user.total_deposit,
              user.try(:members_total_deposit) || 0,
              user.coins,
              user.created_at.strftime('%Y-%m-%d %H:%M:%S'),
              user.try(:coins_used_count) || 0,
              user.children.count
            ]
          end
        end
        send_data csv_string, filename: "invite_list-#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end

  end
end

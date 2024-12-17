class Admins::UsersController < AdminController
  layout 'admin'
  before_action :set_user, only: [:show]

  require 'csv'

  def index
    @clients = User.where(genre: :client).order(created_at: :desc).page(params[:page]).per(10)

    @client_data = @clients.map do |client|
      children_total_deposit = (client.children_members.to_i > 0) ? client.children.sum(:total_deposit) : 0

      {
        id: client.id,
        parent_email: client.parent&.email,
        email: client.email,
        total_deposit: client.total_deposit,
        member_total_deposits: children_total_deposit,
        coins: client.coins,
        total_used_coins: client.children.sum(:coins),
        children_members: client.children_members,
        phone_number: client.phone
      }
    end

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate(headers: true) do |csv|
          csv << [
            "Parent Email", "Email", "Total Deposit", "Member Total Deposits",
            "Coins", "Total Used Coins", "Children Members", "Phone Number"
          ]

          @client_data.each do |client|
            csv << [
              client[:parent_email], client[:email], client[:total_deposit],
              client[:member_total_deposits], client[:coins], client[:total_used_coins],
              client[:children_members], client[:phone_number]
            ]
          end
        end
        render plain: csv_string
      }
    end

  end

  def show
    @promoter_name = @user.email
    @user_coins = @user.coins
  end

  def set_user
    @user = User.find(params[:id])
  end

end

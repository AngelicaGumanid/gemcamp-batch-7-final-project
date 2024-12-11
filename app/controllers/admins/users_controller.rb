class Admins::UsersController < AdminController
  layout 'admin'
  before_action :set_user, only: [:balance_operate]

  def index
    @clients = User.where(genre: :client)

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
  end

  def balance_operate
    @promoter_name = "Promoter123" # Replace this with real data
    @user_coins = @user.coins # Replace this if `coins` is a field
  end

  def set_user
    @user = User.find(params[:id])
  end

end

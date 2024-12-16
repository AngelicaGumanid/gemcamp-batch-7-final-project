class Admins::UsersController < AdminController
  layout 'admin'
  before_action :set_user, only: [:show]

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
  end


  def show
    @promoter_name = @user.email
    @user_coins = @user.coins
  end

  def set_user
    @user = User.find(params[:id])
  end

end

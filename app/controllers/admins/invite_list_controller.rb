class Admins::InviteListController < AdminController
  def index
    @users = User.includes(:parent, :children)
                 .where.not(parent_id: nil)
                 .order(created_at: :desc)

    if params[:parent_email].present?
      @users = @users.joins(:parent).where("users.email ILIKE ?", "%#{params[:parent_email]}%")
    end

    @users = @users.page(params[:page]).per(10)
  end
end

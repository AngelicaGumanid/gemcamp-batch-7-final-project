class Clients::RegistrationsController < Devise::RegistrationsController
  layout 'client'
  def create
    if cookies[:promoter].present?
      promoter_email = cookies[:promoter]
      promoter = User.find_by(email: promoter_email)

      if promoter
        params[:clients_user][:parent_id] = promoter.id
        puts "Assigned parent_id: #{promoter.id}"
      else
        puts "Promoter not found for email: #{promoter_email}"
      end
    end

    super do |resource|
      if resource.persisted? && resource.parent
        resource.parent.increment!(:children_members)
      end
    end
  end

  def new
    cookies[:promoter] = params[:promoter]
    super
  end

  def sign_up_params
    params.require(:clients_user).permit(:email, :password, :password_confirmation, :parent_id)
  end

end

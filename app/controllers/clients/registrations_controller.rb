class Clients::RegistrationsController < Devise::RegistrationsController
  def create
    if cookies[:promoter].present?
      promoter_email = cookies[:promoter]
      promoter = User.find_by(email: promoter_email)

      if promoter
        params[:user][:parent_id] = promoter.id
        puts "Assigned parent_id: #{promoter.id}"
      else
        puts "Promoter not found for email: #{promoter_email}"
      end
    end

    super
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :parent_id)
  end

end

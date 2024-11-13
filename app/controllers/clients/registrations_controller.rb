class Clients::RegistrationsController < Devise::RegistrationsController
  def create
    if cookies[:promoter].present?
      promoter_email = cookies[:promoter]
      promoter = User.find_by(email: promoter_email)

      if promoter
        params[:user][:parent_id] = promoter.id
      end
    end

    super
  end
end

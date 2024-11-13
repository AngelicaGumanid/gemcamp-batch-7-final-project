class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admins_root_path
    else
      clients_root_path
    end
  end
end

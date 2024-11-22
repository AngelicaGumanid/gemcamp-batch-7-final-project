class AdminController < ActionController::Base
  before_action :authenticate_admins_user!
  layout 'admin'
end
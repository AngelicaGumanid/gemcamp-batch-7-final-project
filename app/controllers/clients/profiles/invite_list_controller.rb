class Clients::Profiles::InviteListController < ApplicationController
  layout 'client'

  def index
    @invites = User.where(parent: current_clients_user).page(params[:page]).per(5)
  end
end

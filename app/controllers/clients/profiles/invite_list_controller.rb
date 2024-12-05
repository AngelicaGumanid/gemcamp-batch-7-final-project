class Clients::Profiles::InviteListController < ApplicationController
  layout 'client'

  def index
    @invites = User.where(parent_id: current_clients_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end
end

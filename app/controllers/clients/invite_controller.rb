class Clients::InviteController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @promoter_email = params[:promoter]
    cookies[:promoter] = @promoter_email if @promoter_email.present?

    @qr_code = generate_qr_code(@promoter_email)
    @invite_url = generate_invite_url(@promoter_email)
  end

  private

  def generate_qr_code(promoter_email)
    require 'rqrcode'

    invite_url = generate_invite_url(promoter_email)
    qrcode = RQRCode::QRCode.new(invite_url)
    qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    ).html_safe
  end

  def generate_invite_url(promoter_email)
    base_url = "#{request.base_url}/users/sign_up"
    "#{base_url}?promoter=#{promoter_email}"
  end
end

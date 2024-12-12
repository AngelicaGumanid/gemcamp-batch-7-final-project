class Admins::BannersController < AdminController
  before_action :set_banner, only: [:show, :edit, :update, :destroy, :restore]

  def index
    @banners = Banner.with_deleted.page(params[:page])
  end

  def create
    @banner = Banner.new(banner_params)

    if @banner.save
      redirect_to admins_banners_path, notice: 'Banner was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def new
    @banner = Banner.new
  end

  def update
    if @banner.update(banner_params)
      redirect_to admins_banners_path, notice: 'Banner was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      redirect_to admins_banners_path, notice: 'Banner was successfully deleted.'
    else
      redirect_to admins_banners_path, alert: 'Failed to delete banner.'
    end
  end

  def restore
    if @banner.restore
      redirect_to admins_banners_path, notice: 'Banner was successfully restored.'
    else
      redirect_to admins_banners_path, alert: 'Failed to restore banner.'
    end
  end

  private

  def set_banner
    @banner = Banner.with_deleted.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status)
  end

end

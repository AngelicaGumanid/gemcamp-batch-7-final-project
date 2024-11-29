class Admins::OffersController < AdminController
  layout 'admin'
  before_action :set_offer, only: %i[show edit update destroy]

  def index
    @offers = Offer.all
    @offers = @offers.where(status: params[:status]) if params[:status].present?
    @offers = @offers.search(params[:search]) if params[:search].present?
    @offers = @offers.page(params[:page])
  end

  def show; end

  def new
    @offer = Offer.new
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      redirect_to admins_offers_path, notice: 'Offer was successfully created.'
    else
      render :new
    end
  end

  def update
    if @offer.update(offer_params)
      redirect_to admins_offers_path, notice: 'Offer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to admins_offers_path, notice: 'Offer was successfully destroyed.'
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :status, :amount, :coin)
  end

end
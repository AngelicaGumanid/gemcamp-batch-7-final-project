class Clients::LocationsController < ApplicationController
  layout 'client'

  before_action :authenticate_clients_user!
  before_action :set_location, only: %i[show edit update destroy]

  def index
    @locations = current_clients_user.locations.includes(:region, :province, :city, :barangay)
  end

  def new
    if current_clients_user.locations.count >= 5
      @address_limit_reached = true
    else
      @location = current_clients_user.locations.new
      @default_location = current_clients_user.locations.find_by(is_default: true)
      @address_limit_reached = false
    end
  end

  def create
    @location = current_clients_user.locations.new(location_params)

    if @location.is_default? && current_clients_user.locations.exists?(is_default: true)
      current_clients_user.locations.find_by(is_default: true).update(is_default: false)
    end

    if @location.save
      redirect_to clients_locations_path, notice: 'Location created successfully.'
    else
      render :new, alert: 'Failed to create location.'
    end
  end

  def edit
    @default_location = current_clients_user.locations.find_by(is_default: true)
    @prompt_replace_default = @default_location.present? && !@location.is_default? && @location.id != @default_location.id
  end

  def update
    # @default_location = current_clients_user.locations.find_by(is_default: true)
    # if @location.is_default? && @default_location.present? && @location.id != @default_location.id
    #   @default_location.update(is_default: false)
    # end

    if @location.update(location_params)
      redirect_to clients_locations_path, notice: 'Location updated successfully.'
    else
      render :edit, alert: 'Failed to update location.'
    end
  end


  def destroy
    @location = current_clients_user.locations.find(params[:id])

    if @location.destroy
      redirect_to clients_locations_path, notice: 'Location deleted successfully.'
    else
      redirect_to clients_locations_path, alert: 'Error deleting location.'
    end
  end

  private

  def set_location
    @location = current_clients_user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :address_regions_id, :address_provinces_id, :address_cities_id, :address_barangays_id)
  end
end

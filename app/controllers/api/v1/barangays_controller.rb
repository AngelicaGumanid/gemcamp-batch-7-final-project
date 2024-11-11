class Api::V1::BarangaysController < ApplicationController

  def index
    city = Address::City.find_by_id(params[:city_id])
    barangays = if city
                  city.barangays
                else
                  Address::Barangay.all
                end
    render json: barangays
  end

  def show
    barangay = Address::Barangay.find(params[:id])
    render json: barangay
  end
end
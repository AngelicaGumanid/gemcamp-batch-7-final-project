class Api::V1::ProvincesController < ApplicationController

  def index
    region = Address::Region.find_by_id(params[:region_id])
    provinces = if region
                  region.provinces
                else
                  Address::Province.all
                end

    render json: provinces
  end

  def show
    province = Address::Province.find_by_id(params[:id])
    render json: province
  end
end
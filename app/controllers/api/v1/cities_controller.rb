class Api::V1::CitiesController < ApplicationController

  def index
    province = Address::Province.find_by_id(params[:province_id])
    cities = if province
               province.cities
             else
               Address::City.all
             end

    render json: cities
  end

  def show
    city = Address::City.find(params[:id])
    render json: city
  end
end
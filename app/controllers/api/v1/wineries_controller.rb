class Api::V1::WineriesController < ApplicationController
  def index
    @wineries = Winery.all
    render json: @wineries
  end

  def return_winery_api_results
    url="https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{params["search"]}&inputtype=textquery&fields=photos,id,icon,types,formatted_address,price_level,name,rating,opening_hours,id,plus_code,geometry&key=#{ENV['GOOGLE_PLACES_API']}"
    
    @winery = RestClient.get(url)
    @winery = JSON.parse(@winery)
        
    render json: @winery
  end

end

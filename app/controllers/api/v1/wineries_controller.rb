class Api::V1::WineriesController < ApplicationController
  def index
    @wineries = Winery.all
    render json: @wineries
  end

  def index_filter
    
  end

  def return_winery_api_results
    url="https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{params["search"]}&inputtype=textquery&fields=photos,id,place_id,icon,types,formatted_address,price_level,name,rating,opening_hours,id,plus_code,geometry&key=#{ENV['GOOGLE_PLACES_API']}"

    @winery = RestClient.get(url)

    @winery = JSON.parse(@winery)

    @wineryid = @winery["candidates"][0]["place_id"]

    detailurl="https://maps.googleapis.com/maps/api/place/details/json?placeid=#{@wineryid}&fields=photos,id,place_id,icon,types,formatted_address,price_level,formatted_phone_number,name,rating,opening_hours,id,plus_code,geometry&key=#{ENV['GOOGLE_PLACES_API']}"

    @winerydetail = RestClient.get(detailurl)

    @winerydetail = JSON.parse(@winerydetail)

    render json: @winerydetail["result"]
  end

end

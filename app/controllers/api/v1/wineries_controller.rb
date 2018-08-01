class Api::V1::WineriesController < ApplicationController

  def index

    select_sql = " wineries y"
    join_sql = ""
    filter_sql = ""

    # replace with params
    grape = params["grape"]
    region = params["region"]

    # default region to Napa Valley
    if !grape and !region
      region = "Napa Valley"
    end

    puts("region: #{region}")
    puts("grape: #{grape}")

    # build sql needed to query for a grape (varietal)
    if grape
      select_sql = select_sql + ", wines w, grapes g"
      join_sql = join_sql + " y.id = w.winery_id and g.id = w.grape_id"
      filter_sql = filter_sql + " and g.name='#{grape}'"
    end

    # build sql needed to query for a region
    if region
      select_sql = select_sql + ", regions r"
      if grape
        join_sql = join_sql + " and"
      end
      join_sql = join_sql + " r.id = y.region_id"
      filter_sql = filter_sql + " and r.name='#{region}'"
    end

    # put it all together
    sql = "select distinct y.* from" + select_sql
    if grape || region
      sql = sql + " where " + join_sql + filter_sql
    end

    puts("sql: #{sql}")

    #    @wineries = Winery.all
    @wineries = Winery.find_by_sql(sql)

    render json: @wineries
  end

  def create
    @trip = Trip.find_by(user_id: params[:id])
    @winery = Winery.find(params[:winery_id])
    @tw = TripWinery.new(trip_id: @trip.id, winery_id: @winery.id)
    if @tw.save
      @wineries = TripWinery.all.select {|item| item.trip_id == @trip.id }
      @myWineries = @wineries.map { |winery| Winery.find(winery.winery_id) }
      render json: @myWineries
    else
      render json: {
        message: "error on saving trip winery"
      }, status: :unprocessable_entity
    end
  end

  def return_winery_api_results
    url="https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{URI.encode_www_form_component(params["search"])}&inputtype=textquery&fields=photos,id,place_id,icon,types,formatted_address,price_level,name,rating,opening_hours,id,plus_code,geometry&key=#{ENV['GOOGLE_PLACES_API']}"

    @winery = RestClient.get(url)

    @winery = JSON.parse(@winery)

    if @winery["candidates"] != []

        @wineryid = @winery["candidates"][0]["place_id"]

        detailurl="https://maps.googleapis.com/maps/api/place/details/json?placeid=#{@wineryid}&fields=photos,id,place_id,icon,types,formatted_address,price_level,formatted_phone_number,name,rating,opening_hours,id,plus_code,geometry&key=#{ENV['GOOGLE_PLACES_API']}"

        @winerydetail = RestClient.get(detailurl)

        @winerydetail = JSON.parse(@winerydetail)

        render json: @winerydetail["result"]
    else
      render json: {message: "No Data"}
    end
  end

end

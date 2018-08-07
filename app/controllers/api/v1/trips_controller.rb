class Api::V1::TripsController < ApplicationController

  def show

    # this method not called by front end - see wineries_controller show instead
    # example route http://localhost:3000/api/v1/trips/4
    sql = "select y.* from wineries y, trip_wineries tw, trips t where t.id = tw.trip_id and tw.winery_id = y.id and t.id = #{params[:id]} order by y.name"

    puts sql

    @wineries = Winery.find_by_sql(sql)
    render json: @wineries

  end

end

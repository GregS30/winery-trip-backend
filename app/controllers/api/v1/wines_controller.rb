class Api::V1::WinesController < ApplicationController

  def index
    # @winesFound = Wine.all.select { |wine| wine.winery_id == params["wineryId"].to_i }

    sql = "select * from wines where winery_id=#{params["wineryId"].to_i}"

    puts("sql: #{sql}")

    @winesFound = Wine.find_by_sql(sql)

    render json: @winesFound
  end

end

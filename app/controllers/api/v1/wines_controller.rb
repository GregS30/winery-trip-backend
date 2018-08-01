class Api::V1::WinesController < ApplicationController

  def index
    @winesFound = Wine.all.select { |wine| wine.winery_id == params["wineryId"].to_i }
    render json: @winesFound
  end

end

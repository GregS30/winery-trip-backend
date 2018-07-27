class Api::V1::WineriesController < ApplicationController
  def index
    @wineries = Winery.all
    render json: @wineries
  end

  def show
  end

end

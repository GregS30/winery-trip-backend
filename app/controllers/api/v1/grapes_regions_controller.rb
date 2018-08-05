class Api::V1::GrapesRegionsController < ApplicationController
  def index
    @grapes = Grape.all.order(:name)
    @regions = Region.all.order(:name)
    render json: {grapes: @grapes, regions: @regions}
  end
end

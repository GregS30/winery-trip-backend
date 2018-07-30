class Api::V1::GrapesController < ApplicationController
  def index
    @grapes = Grape.all
    render json: @grapes
  end
end

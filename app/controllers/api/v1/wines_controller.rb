class Api::V1::WinesController < ApplicationController
  def index
    render json: Wine.all
  end
end

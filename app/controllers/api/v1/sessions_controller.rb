class Api::V1::SessionsController < ApplicationController

  def create
    @user = User.find_by(name: params["username"])
    if (@user && @user.authenticate(params["password"]))
      render json: {
        username: @user.name,
        id: @user.id,
        token: gen_token()
      }
    else
      render json: {
        errors: "Those credentials don't match our wine database!"
      }, status: :unauthorized
    end
  end

end

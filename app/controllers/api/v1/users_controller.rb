class Api::V1::UsersController < ApplicationController
  
  def create
    @user = User.new
    @user.name = params[:username] 
    @user.password = params[:password]
    if (@user.save)
        render json: {
              username: @user.username,
              id: @user.id,
              # token: gen_token()
            }
    else
        render json: {
          errors: @user.errors.full_messages
        }, status: :unprocessable_entity
    end
  end

end

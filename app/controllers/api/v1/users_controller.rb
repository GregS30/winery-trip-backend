class Api::V1::UsersController < ApplicationController
  # before_action :authenticate, only: [show]
  # before_action :requires_user, only: [show]

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new
    @user.name = params[:username]
    @user.password = params[:password]
    if @user.save
      @trip = Trip.new
      @trip.name = @user.name
      @trip.user_id = @user.id
      if @trip.save
        render json: {
              username: @user.name,
              id: @user.id,
              token: generate_token()
            }
      end
    else
      render json: {
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def current_user
    @user = User.find_by(id: get_token_payload("sub"))
    if !!@user
      render json: {
        username: @user.name,
        id: @user.id
      }
    else
      render json: {
        message: "Invalid token"
      }, status: :unauthorized
    end
  end

end

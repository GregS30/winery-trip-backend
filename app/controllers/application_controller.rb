class ApplicationController < ActionController::API

  #create token helpers
  def secret_key
    ENV["SECRET_KEY"]
  end


  def payload
    {
      sub: @user.id
    }
  end

  def generate_token
    JWT.encode payload(), secret_key(), "HS256"
  end

  #get tokens and validate them
  def get_token
    request.headers['Authorization']
  end

  def decoded_token
    begin
      JWT.decode get_token(), secret_key(), true
    rescue JWT::DecodeError => e
      nil
    end
  end

  #login logic
  def logged_in?
    !!decoded_token
  end

  def authenticate
    if !logged_in?
      render json:{
        message: "Authorization failed!"
      }, status: :unauthorized
    end
  end

  def requires_user
    @user = User.find_by(id: params[:id])
    if decoded_token()[0]['sub'] != @user.id
      render json:{
        message: "Authorization failed!"
      }, status: :unauthorized
    end
  end

  def get_token_payload(key)
    begin
      decoded_token[0][key]
    rescue NoMethodError => e
      nil
    end
  end

end

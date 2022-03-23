class UsersController < ApplicationController

  before_action :authorize_request, except: %i[login]
  before_action :verify_params, only:  :login

  def create
    @user = User.create(user_params)
    if @user.valid?
      token - encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid email and password" }
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      payload = { user_id: user.id }
      token = JsonWebToken.encode(payload)
      time = Time.now + 24.hours.to_i
      render json: { user: user, token: token, expires_at: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def me
    render json: {user: @current_user}
  end

  private
  def user_params
    params.permit(:email, :password, :name)
  end
  def verify_params
    if params[:email].blank? || params[:password].blank?
      render json: {error: "Invalid email or password"}
    end
  end
end

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  def not_found
    render json: {error: "Not Found"}
  end


  def authorize_request
    header = request.headers['Authorization']
    if header != nil
      token = header.split(' ').last
      if !token.blank?
        begin
          @decoded = JsonWebToken.decode(token)
          @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound =>e
          render json: {errors: "Record Not Found"}, status: :unauthorized
        rescue JWT::DecodeError
          render json: {errors: "Invalid Token"}, status: :unauthorized
        end
      else
        render json: {errors: "Invalid Token"}, status: :unauthorized
      end

    else
      render json: {errors: "Invalid Token"}, status: :unauthorized
    end
  end

  def check_if_customer()
    @current_user.user_type
    unless @current_user.isCustomer?
      render json: { message: "Customers can only access this resource" }
    end
  end

end

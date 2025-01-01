class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_request, only: [:register, :login, :verify_email]

  def login
    result = UserService.login(params[:email], params[:password])

    if result[:success]
      render json: { token: result[:token], user: result[:user] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unauthorized
    end
  end


  def register
    result = UserService.register(user_params)

    if result[:success]
      render json: { message: result[:message], user: result[:user] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end


  def verify_email
    result = UserService.verify_email(params[:code])

    if result[:success]
      render json: { message: result[:message] }, status: result[:status]
    else
      render json: { error: result[:error], details: result[:details] }, status: result[:status]
    end
  end

  def user_params
    params.permit(:email, :full_name, :password, :usertype)
  end

end

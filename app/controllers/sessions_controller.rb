class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_request, only: [:new, :create, :destroy, :register, :create_user]

  @registration_errors = []
  @login_errors = []

  def new
  end

  def create
    @login_errors = []
    result = UserService.login(params[:email], params[:password])
    if result[:success]
      session[:user_id] = result[:user].id
      $current_user = result[:user] # Set the global variable
      redirect_to root_path, notice: 'Logged in successfully'
    else
      @login_errors = result[:errors]
      render :new, status: :unprocessable_entity
    end
  end

  def register

  end

  def create_user
    @registration_errors =[]
    user_data = user_params.to_h
    user_data[:usertype] = "Admin"
    result = UserService.register(user_data)

    if result[:success]

      redirect_to login_path
    else
      @registration_errors = result[:errors]
      render :register, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    $current_user = nil
    redirect_to login_path, notice: 'Logged out successfully'
  end

  def exam_params
    params.require(:exam).permit(:title, :subject, :total_marks, :start_time, :duration, :end_time)
  end


  def user_params
    params.permit(:email, :full_name, :password, :usertype)
  end

end

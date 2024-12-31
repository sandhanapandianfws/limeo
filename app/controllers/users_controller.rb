class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_request, only: [:register, :login, :verify_email]

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate_password(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      user.password = nil
      user.password_digest = nil
      if !user.email_verified
        render json: { errors: ['Please verify your email to login'] }, status: :unauthorized
      else
        $redis.set(token, user.to_json, ex: 1 * 60)

        render json: { token: token, user: user }, status: :ok
      end
    else
      if user
        InvalidLoginAttemptWorker.perform_async(user.id)
      end


      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  def register
    # user_params = params.require(:user).permit(:email, :full_name, :password)
    # Extract parameters
    email = user_params[:email]
    full_name = user_params[:full_name]
    password = user_params[:password]
    usertype = user_params[:usertype]

    # Validate parameters
    errors = []
    errors << I18n.t('user.registration.invalid.email') unless email =~ URI::MailTo::EMAIL_REGEXP
    errors << I18n.t('user.registration.empty.first_name') if full_name.blank?
    errors << "Password cannot be empty" if password.blank?
    errors << "Usertype cannot be empty" if usertype.blank?

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
    else
      # Create the user (assuming the User model exists)
      user = User.new(email: email, full_name: full_name, usertype: usertype)
      user.password = password
      if user.save
        UserMailer.verification_email(user).deliver_now
        render json: { message: "User registered successfully", user: user }, status: :created
      else
        Rails.logger.debug user.errors.full_messages
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end


  def user_params
    params.permit(:email, :full_name, :password, :usertype)
  end

  def verify_email
    code = params[:code]

    if code.blank?
      render json: { error: 'Verification code is missing' }, status: :bad_request and return
    end

    user = User.find_by(email_verification_code: code)

    if user.nil?
      render json: { error: 'Invalid verification code' }, status: :not_found and return
    end

    if user.email_verified?
      render json: { message: 'Email already verified' }, status: :ok and return
    end
    if user.update(email_verified: true, email_verification_code: nil, email_link_used: true)
      render json: { message: 'Email successfully verified' }, status: :ok
    else
      render json: { error: 'Failed to update user', details: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: 'Something went wrong', details: e.message }, status: :internal_server_error
  end
end

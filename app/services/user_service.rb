# app/services/user_service.rb
class UserService
  def self.login(email, password)
    user = User.find_by(email: email)

    if user&.authenticate_password(password)
      unless user.email_verified
        return { success: false, errors: [I18n.t('user.login.error.email_not_verified')] }
      end

      token = JsonWebToken.encode(user_id: user.id)
      $redis.set(token, user.to_json, ex: 30 * 60)

      # Hide sensitive data
      user.password = nil
      user.password_digest = nil

      { success: true, token: token, user: user }
    else
      InvalidLoginAttemptWorker.perform_async(user.id) if user
      return { success: false, errors: [I18n.t('user.login.error.invalid_email_password')] }
    end
  end

  def self.register(user_params)
    email = user_params[:email]
    full_name = user_params[:full_name]
    password = user_params[:password]
    usertype = user_params[:usertype]

    # Validate input
    errors = []
    errors << I18n.t('user.registration.invalid.email') unless email =~ URI::MailTo::EMAIL_REGEXP
    errors << I18n.t('user.registration.empty.first_name') if full_name.blank?
    errors << I18n.t('user.registration.empty.password') if password.blank?
    errors << I18n.t('user.registration.empty.usertype') if usertype.blank?

    return { success: false, errors: errors } if errors.any?

    # Create the user
    user = User.new(email: email, full_name: full_name, usertype: usertype, password: password)

    if user.save
      UserMailer.verification_email(user).deliver_now
      { success: true, message: I18n.t('user.registration.success_msg'), user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end

  rescue ActiveRecord::RecordNotUnique => e
    if e.message.include?('email')
      { success: false, errors: [I18n.t('user.registration.dberror.duplicate.email')] }
    else
      { success: false, errors: [I18n.t('user.registration.dberror.duplicate.unique_violation')] }
    end
  rescue StandardError => e
    # Catch any other exceptions
    Rails.logger.error("User registration failed: #{e.message}")
    { success: false, errors: [I18n.t('user.registration.unexpected_error')] }
  end

  def self.verify_email(code)
    return { success: false, error: I18n.t('user.verify_email.error.code_missing'), status: :bad_request } if code.blank?

    user = User.find_by(email_verification_code: code)
    return { success: false, error: I18n.t('user.verify_email.error.invalid_code'), status: :not_found } if user.nil?

    if user.email_verified?
      return { success: true, message: I18n.t('user.verify_email.error.email_already_verified'), status: :ok }
    end

    if user.update(email_verified: true, email_verification_code: nil, email_link_used: true)
      { success: true, message: I18n.t('user.verify_email.success'), status: :ok }
    else
      { success: false, error: I18n.t('user.verify_email.error.save_failed'), details: user.errors.full_messages, status: :unprocessable_entity }
    end
  rescue => e
    { success: false, error: I18n.t('user.verify_email.success'), details: e.message, status: :internal_server_error }
  end
end

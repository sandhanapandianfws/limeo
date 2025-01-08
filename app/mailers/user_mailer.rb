class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def verification_email(user)
    @user = user
    @verification_link = "http://localhost:4009/users/verifyEmail?code=#{@user.email_verification_code}"
    # {@user.email_verification_code}
    mail(to: @user.email, subject: 'Welcome to Limeo! Let\'s get started 🚀')
  end

  def login_attempt_failed(user_id)

    puts user_id, ' <<#1>> - req processed at'
    @user = User.find(user_id)
    puts @user.id, ' - req processed at - ', Time.current
    mail(
      from: "No Reply <sandhanapandianrr@gmail.com>",
      to: @user.email,
      subject: "Alert: Login Attempt Failed on Your Limeo Account"
    )
  end
end

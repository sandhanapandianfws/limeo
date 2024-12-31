class InvalidLoginAttemptWorker
  include Sidekiq::Worker

  def perform(user_id)
    puts user_id, ' - req received at', Time.current
    UserMailer.login_attempt_failed(user_id).deliver_later(wait: 10.seconds)
  end
end

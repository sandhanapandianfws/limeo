class NewCourseInviteWorker
  include Sidekiq::Worker

  def perform(*args)
    puts "Doing work with #{args}"
  end
end


namespace :course do
  desc "Fetch all courses subscribed today"
  task today_subscriptions: :environment do
    all_courses_subscription = CourseSubscription.where("DATE(created_at) = ?", Date.today)

    all_courses_subscription.each do |subscription|
      course = subscription.course
      user = subscription.user
      puts "Course : #{course.title} subscribed user #{user.full_name} | Author : #{course.author.email}"

      SubscriptionMailer.user_subscription_email(user, course).deliver_now

      SubscriptionMailer.author_subscription_email(course.author, user, course).deliver_now
    end
  end
end
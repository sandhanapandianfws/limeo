
namespace :course do
  desc "Fetch all courses subscribed today"
  task today_subscriptions: :environment do
    all_courses = CourseSubscription.where("DATE(created_at) = ?", Date.today)
    puts "Fetched #{all_courses.count} courses."
  end
end
# Set the Rails environment
set :environment, "development" # or "production"

# Set the output log file
set :output, "log/cron.log"

# Schedule the task
every 5.minutes do
  # Option 1: Call the model method
  # runner "Course.fetch_all_courses"

  # Option 2: Run the rake task
  puts "Today [#{Date.today}] subscriptions scheduler called"
  rake "course:today_subscriptions"
end

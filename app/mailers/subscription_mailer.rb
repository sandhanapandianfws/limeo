class SubscriptionMailer < ApplicationMailer

  def user_subscription_email(user, course)
    @user = user
    @course = course
    mail(to: @user.email, subject: "You have subscribed to #{@course.title}")
  end

  # Notify the course author about the subscription
  def author_subscription_email(author, user, course)
    @author = author
    @user = user
    @course = course
    mail(to: @author.email,
         subject: "#{@user.full_name} has subscribed to your course #{@course.title}")
  end

end

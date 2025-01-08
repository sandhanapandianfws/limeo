class CourseSubscriptionsController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :authenticate_request

  before_action :set_course, only: [:subscribe, :unsubscribe]

  def subscribe
    p @course.id
    @subscription = @course.course_subscriptions.new(user: @current_user)

    if @subscription.save
      render json: { message: 'Successfully subscribed to the course' }, status: :created
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unsubscribe
    @subscription = @course.course_subscriptions.find_by(user: @current_user)

    if @subscription
      @subscription.destroy
      render json: { message: 'Successfully unsubscribed from the course' }, status: :ok
    else
      render json: { error: 'Subscription not found' }, status: :not_found
    end
  end

  def subscribers
    users = @course.users
    render json: users, status: :ok
  end

  private

  def set_course
    puts "Before action: setting course"
    @course = Course.find_by(id: params[:id])
    render json: { error: 'Course not found' }, status: :not_found unless @course
  end

end

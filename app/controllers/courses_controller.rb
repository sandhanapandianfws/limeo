class CoursesController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_course, only: %i[show update destroy]

  before_action :authenticate_request

  # GET /courses
  def index
    courses = Course.all
    render json: courses
  end

  # GET /courses/:id
  def show
    render json: @course
  end

  # POST /courses
  def create
    course = Course.new(course_params)
    p @current_user
    course.createdby_id = @current_user.id
    course.updatedby_id = @current_user.id
    if course.save
      render json: course, status: :created
    else
      render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /courses/:id
  def update
    course_params[:updatedby_id] = @current_user.id
    if @course.update(course_params)
      render json: @course
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /courses/:id
  def destroy
    @course.destroy
    render json: { message: 'Course deleted successfully' }, status: :ok
  end

  private

  # Find course by ID
  def set_course
    @course = Course.find_by(id: params[:id])
    render json: { error: 'Course not found' }, status: :not_found unless @course
  end

  # Strong parameters
  def course_params
    params.require(:course).permit(
      :title,
      :ispaid_course,
      :ispracticetest_course,
      :imagethumbnail,
      :imagelarge,
      :no_of_subscribers,
      :rating,
      :no_of_reviews,
      :no_of_published_lectures,
      :description,
      :primarycategory_id,
      :primarysubcategory_id,
      :author_id,
      :is_course_completion,
      :createdby_id,
      :updatedby_id,
      :instruction_level,
      :published_time,
      :contentinfo
    )
  end
end

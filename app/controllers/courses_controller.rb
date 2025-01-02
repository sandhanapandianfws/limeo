class CoursesController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_course, only: %i[show update destroy create_section get_sections]

  before_action :set_section, only: %i[create_lecture destroy_section]

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
    user = User.find_by(id: course_params[:author_id])
    if user == nil
      render json: { success: false, errors: ["Author id is invalid"] }, status: :bad_request and return
    end
    course = Course.new(course_params)
    course.author = user
    course.updated_by = course.created_by = @current_user
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

  def create_section
    section = @course.sections.build(section_params)

    section.createdby_id = @current_user.id
    section.updatedby_id = @current_user.id
    if section.save
      render json: { message: 'Section created successfully', section: section }, status: :created
    else
      render json: { errors: section.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy_section
    if @section.destroy
      render json: { message: 'Section deleted successfully' }, status: :ok
    else
      render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /courses/:course_id/sections
  def get_sections
    sections = @course.sections
    render json: sections, status: :ok
  end

  def create_lecture
    lecture = @section.lectures.new(lecture_params)
    lecture.createdby_id = @current_user.id
    lecture.updatedby_id = @current_user.id

    if lecture.save
      render json: { message: 'Lecture created successfully', lecture: lecture }, status: :created
    else
      render json: { errors: lecture.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_section
    @section = Section.find_by(id: params[:id])
    render json: { error: 'Section not found' }, status: :not_found unless @section
  end

  def find_lecture
    @lecture = @section.lectures.find_by(id: params[:id])
    render json: { error: 'Lecture not found' }, status: :not_found unless @lecture
  end

  # Find course by ID
  def set_course
    @course = Course.find_by(id: params[:id])
    render json: { error: 'Course not found' }, status: :not_found unless @course
  end


  # Find course before creating or fetching sections
  def find_course
    @course = Course.find_by(id: params[:course_id])
    unless @course
      render json: { error: 'Course not found' }, status: :not_found
    end
  end



  def lecture_params
    params.require(:lecture).permit(:title,
                                    :content_type,
                                    :content_url)
  end

  def section_params
    params.require(:section).permit(
      :title,
      :author_id,
      :section_order,
      :description
    )
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

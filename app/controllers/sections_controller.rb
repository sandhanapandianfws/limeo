class SectionsController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_section, only: %i[show update destroy]

  before_action :authenticate_request

  def index
    courses = Section.find_by_course_id(params[:course_id])
    render json: courses
  end

  def show
    render json: @section
  end

  def create

    # Validate parameters
    errors = []

    errors << "Course cannot be empty" if section_params[:course_id].blank?
    course = Course.find_by(id: section_params[:course_id])

    errors << "Course not found" unless course

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
    else
      section = Section.new(section_params)

      p @current_user
      section.createdby_id = @current_user.id
      section.updatedby_id = @current_user.id
      if section.save
        render json: section, status: :created
      else
        render json: { errors: section.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    section_params[:updatedby_id] = @current_user.id
    if @section.update(course_params)
      render json: @section
    else
      render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /courses/:id
  def destroy
    @section.destroy
    render json: { message: 'Section deleted successfully' }, status: :ok
  end

  private

  # Find course by ID
  def set_course
    @section = Section.find_by(id: params[:id])
    render json: { error: 'Section not found' }, status: :not_found unless @section
  end

  # Strong parameters
  def section_params
    params.require(:section).permit(
      :title,
      :author_id,
      :createdby_id,
      :updatedby_id,
      :course_id,
      :section_order,
      :description
    )
  end
end

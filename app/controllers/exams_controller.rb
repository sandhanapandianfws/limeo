class ExamsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_request, only: [:index, :show, :new, :create, :edit, :destroy, :update]
  before_action :set_exam, only: %i[show edit update destroy]

  def index
    @exams = Exam.all
  end

  def show
  end

  def new
    @exam = Exam.new
  end

  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      redirect_to @exam, notice: 'Exam was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @exam.update(exam_params)
      redirect_to @exam, notice: 'Exam was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exam.destroy
    # redirect_to exams_url, notice: 'Exam was successfully destroyed.'
  end

  private

  def set_exam
    @exam = Exam.find(params[:id])
  end

  def exam_params
    params.require(:exam).permit(:title, :subject, :total_marks, :start_time, :duration, :end_time)
  end
end

class CategoriesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_request
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  def index
    categories = Category.includes(:subcategories).all
    render json: categories, include: ['subcategories']
  end

  # GET /categories/:id
  def show
    render json: @category, include: ['subcategories']
  end

  # POST /categories
  def create
    p category_params
    category = Category.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/:id
  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:id
  def destroy
    @category.destroy
    head :no_content
  end

  private

  # Set category based on the ID in the params
  def set_category
    @category = Category.find_by(id: params[:id])

    unless @category
      render json: { error: 'Category not found' }, status: :not_found
    end
  end

  # Only allow a list of trusted parameters through
  def category_params
    params.require(:category).permit(:title, :icon, :type, :parent_category_id)
  end
end

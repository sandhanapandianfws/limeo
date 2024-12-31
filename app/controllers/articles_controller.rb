class ArticlesController < ApplicationController
  before_action :authenticate_request

  def new
    @article = Article.new
  end

  def create
    articles_params = params.require(:article).permit(:title, :text)

    errors = []
    errors << "Title cannot be empty" if articles_params[:title].blank?
    errors << "Text cannot be empty" if articles_params[:text].blank?

    if errors.any?
      render json: { errors: errors }, status: :bad_request
    else

      article = Article.new(text: articles_params[:text], title: articles_params[:title])

      if article.save
        render json: { message: "User registered successfully", article: article }, status: :created
      else
        render json: { errors: article.errors.full_messages }, status: :internal_server_error
      end
    end

  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  def index
    p "A Contr"
    articles = Article.all
    render json: articles
  end

  def show
    @article = Article.find(params[:id])
    puts "TEst ------ ", @article
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)
  end

end

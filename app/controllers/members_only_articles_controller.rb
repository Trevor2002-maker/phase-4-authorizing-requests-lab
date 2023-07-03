class MembersOnlyArticlesController < ApplicationController
  before_action :authenticate_user, only: [:index, :show]

  def index
    if current_user
      articles = Article.where(is_member_only: true)
      render json: articles.map { |article| article_json(article) }
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def show
    article = Article.find(params[:id])
    if article.is_member_only
      render json: article_json(article)
    else
      render json: { error: "This article is not for members only." }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user
    unless current_user
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def article_json(article)
    {
      id: article.id,
      title: article.title,
      minutes_to_read: article.minutes_to_read,
      author: article.author,
      preview: article.preview
    }.compact
  end
end
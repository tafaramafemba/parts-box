class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: [:like, :unlike]

  def index
    @blog_posts = BlogPost.published.order(published_date: :desc)
  end

  def show
    @blog_post = BlogPost.find(params[:id])
  end

  def like
    if current_user.likes.find_by(blog_post: @blog_post)
      render json: { error: 'Already liked' }, status: :unprocessable_entity
    else
      current_user.likes.create(blog_post: @blog_post)
      render json: { likes_count: @blog_post.likes_count }
    end
  end
  
  def unlike
    like = current_user.likes.find_by(blog_post: @blog_post)
    if like
      like.destroy
      render json: { likes_count: @blog_post.likes_count }
    else
      render json: { error: 'Not liked yet' }, status: :unprocessable_entity
    end
  end

private

def set_blog_post
  @blog_post = BlogPost.find(params[:id])
end  
  
end
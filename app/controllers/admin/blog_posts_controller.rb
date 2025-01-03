class Admin::BlogPostsController < Admin::BaseController

  layout 'admin'

  before_action :set_blog_post, only: [:edit, :update, :destroy]

  def index
    @blog_posts = BlogPost.all.order(published_date: :desc)
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)
    if @blog_post.save
      redirect_to admin_blog_posts_path, notice: 'Blog post created successfully!'
    else
      Rails.logger.debug(@blog_post.errors.full_messages)  # Debugging line
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to admin_blog_posts_path, notice: 'Blog post updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to admin_blog_posts_path, notice: 'Blog post deleted successfully!'
  end

  private

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :author, :published_date, :cover_image, content_images: [])
  end
end

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @blog_post = BlogPost.find(params[:blog_post_id])
    @comment = @blog_post.comments.build(comment_params)
    @comment.user_name = current_user.username

    if @comment.save
      redirect_to blog_post_path(@blog_post)
    else
      redirect_to blog_post_path(@blog_post), alert: 'Failed to add comment.'
    end
  end

  def like
    @comment = Comment.find(params[:id])
    if current_user.comment_likes.find_by(comment: @comment)
      render json: { error: 'Already liked' }, status: :unprocessable_entity
    else
      current_user.comment_likes.create(comment: @comment)
      render json: { likes_count: @comment.likes_count }
    end
  end

  def unlike
    @comment = Comment.find(params[:id])
    like = current_user.comment_likes.find_by(comment: @comment)
    if like
      like.destroy
      render json: { likes_count: @comment.likes_count }
    else
      render json: { error: 'Not liked yet' }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_comment_id)
  end
end


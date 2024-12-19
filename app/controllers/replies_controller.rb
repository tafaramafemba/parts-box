class RepliesController < ApplicationController
  def create
    comment = Comment.find(params[:comment_id])
    blog_post = comment.blog_post  # Get the blog post from the associated comment

    # Create the reply
    reply = comment.replies.create(user_name: current_user.username, content: params[:reply_content], blog_post: blog_post)

    if reply.save
      redirect_to blog_post_path(blog_post), notice: 'Reply was successfully created.'
    else
      Rails.logger.error("Reply errors: #{reply.errors.full_messages.join(', ')}")
      redirect_to blog_post_path(blog_post), alert: 'Error creating reply.'
    end
  end
end


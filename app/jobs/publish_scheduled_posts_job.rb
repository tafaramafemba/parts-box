class PublishScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform
    # Find posts scheduled for today or earlier that aren't published yet
    BlogPost.where("published_date <= ? AND published = ?", Date.today, false).find_each do |post|
      post.update(published: true)
      BlogMailer.post_published_email(post).deliver_now
    end
  end
end


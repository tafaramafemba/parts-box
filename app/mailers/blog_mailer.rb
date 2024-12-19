class BlogMailer < ApplicationMailer
  def post_published_email(post)
    @post = post
    mail(to: "info@erigoinc.co.zw", subject: "Scheduled Blog Post Published")
  end
end

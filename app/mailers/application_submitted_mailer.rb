# app/mailers/application_submitted_mailer.rb
class ApplicationSubmittedMailer < ApplicationMailer
  def submitted(user, application)
    @user = user
    @application = application

    mail(to: @user.email, subject: "Your Seller Application has been Submitted!")
  end
end
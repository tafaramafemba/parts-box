# app/mailers/application_submitted_mailer.rb
class ApplicationSubmittedMailer < ApplicationMailer
  def submitted(user, application)
    @user = user
    @application = application

    mail(to: @user.email, subject: "Your Application for #{@application.name} has been Submitted!")
  end
end
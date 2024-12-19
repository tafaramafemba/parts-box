# app/mailers/application_rejected_mailer.rb
class ApplicationRejectedMailer < ApplicationMailer
  def rejected(user, application)
    @user = user
    @application = application

    mail(to: @user.email, subject: "Application Update") 
  end
end
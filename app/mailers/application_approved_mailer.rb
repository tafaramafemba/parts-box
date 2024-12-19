# app/mailers/application_approved_mailer.rb
class ApplicationApprovedMailer < ApplicationMailer
  def approved(user, application)
    @user = user
    @application = application

    mail(to: @user.email, subject: "Congratulations! Your Application has been Approved!")
  end
end
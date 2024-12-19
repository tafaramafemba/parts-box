class VerificationMailer < ApplicationMailer
  def send_verification_code(email, code)
    @code = code
    mail(to: email, subject: "Your Verification Code")
  end
end

class SellerApplicationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @seller_application = current_user.build_seller_application
  end

  def create
    @seller_application = current_user.build_seller_application(seller_application_params)
    @seller_application.status = "pending"

    if @seller_application.save
      current_user.update(seller_status: "pending")
      redirect_to root_path, notice: "Application submitted successfully. Pending admin review."
      ApplicationSubmittedMailer.submitted(@seller_application.user, @seller_application).deliver_now
    else
      render :new, alert: "Failed to submit application."
    end
  end

  def send_verification_code
    otp = SecureRandom.random_number(1000..9999) # Generates a 4-digit code
    session[:email_verification_code] = otp

    # Send the OTP to the user's email
    VerificationMailer.send_verification_code(params[:email], otp).deliver_now
    Rails.logger.info "Verification code: #{otp}"

    render json: { status: "OTP sent" }
  end
  

  private

  def seller_application_params
    params.require(:seller_application).permit(:first_name, :last_name, :email, :phone_number, :id_document, :address, :business_name, :business_registration_number, :business_registration_document)
  end
end
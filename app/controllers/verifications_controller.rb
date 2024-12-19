class VerificationsController < ApplicationController
  def verify_email
    submitted_code = params[:code] || params[:verification][:code]

    if submitted_code == session[:email_verification_code].to_s
      render json: { status: "success" }
      Rails.logger.debug("Session OTP: #{session[:email_verification_code]}")
      Rails.logger.debug("Submitted Code: #{submitted_code}")

    else
      render json: { status: "failed" }, status: :unprocessable_entity
      Rails.logger.debug("Session OTP: #{session[:email_verification_code]}")
      Rails.logger.debug("Submitted Code: #{submitted_code}")

    end
  end
end

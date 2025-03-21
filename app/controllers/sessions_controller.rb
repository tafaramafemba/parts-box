class SessionsController < Devise::SessionsController
    def create
      if verify_recaptcha
        super
      else
        flash[:alert] = "reCAPTCHA verification failed. Please try again."
        redirect_to new_user_session_path
      end
    end
  end
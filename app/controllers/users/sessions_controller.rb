class Users::SessionsController < Devise::SessionsController
    prepend_before_action :check_recaptcha, only: [:create]

    private
  
    def check_recaptcha
      unless verify_recaptcha
        flash[:alert] = "reCAPTCHA verification failed. Please try again."
        redirect_to new_user_session_path
      end
    end
  end
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params

  prepend_before_action :check_recaptcha, only: [:create]

  private

  def check_recaptcha
    unless verify_recaptcha
      self.resource = resource_class.new(sign_up_params)
      resource.validate # Look for any other validation errors
      flash[:alert] = "reCAPTCHA verification failed. Please try again."
      respond_with_navigational(resource) { render :new }
    end
  end

  protected

  # Permit username parameter during sign-up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :phone_number])
  end
end

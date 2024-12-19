class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params

  protected

  # Permit username parameter during sign-up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
  end

  def 
end

class ApplicationController < ActionController::Base
  before_action :set_current_user
  layout :layout_by_resource
  helper_method :current_cart


  before_action :authenticate_admin!, if: :admin_namespace?

  before_action :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :phone_number])
  end

  def current_cart
    # Find cart for the current user or initialize a new one
    @current_cart ||= Cart.find_or_create_by(user_id: current_user&.id || session[:cart_id])
  end

  private

  def set_current_user
    Current.user = current_user if user_signed_in?
  end

  def admin_namespace?
    request.path.start_with?('/admin')
  end

  def layout_by_resource
    if devise_controller? && resource_class == Admin
      "admin"
    else
      "application"
    end
  end
end

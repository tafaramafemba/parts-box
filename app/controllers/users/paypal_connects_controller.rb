require 'net/http'
require 'uri'

class Users::PaypalConnectsController < ApplicationController
  before_action :authenticate_user!

  PAYPAL_CLIENT_ID = ENV['PAYPAL_CLIENT_ID']
  PAYPAL_SECRET = ENV['PAYPAL_CLIENT_SECRET']
  PAYPAL_REDIRECT_URI = Rails.application.routes.url_helpers.callback_users_paypal_connects_url

  def new
    # Render the page where users can either connect an existing PayPal account or create one
  end

  def create_account
    # Generate PayPal Partner Onboarding URL
    paypal_url = build_paypal_connect_url
    redirect_to paypal_url, allow_other_host: true
  end

  def connect_existing_account
    # Allow users to manually input their PayPal Merchant ID
    if params[:paypal_merchant_id].present?
      current_user.update!(paypal_merchant_id: params[:paypal_merchant_id])
      redirect_to edit_account_settings_path, notice: "Your PayPal account has been successfully connected."
    else
      redirect_to new_users_paypal_connects_path, alert: "PayPal Merchant ID cannot be blank."
    end
  end

  def callback
    # Handle PayPal callback with authorization code
    if params[:code].present?
      access_token_response = exchange_code_for_token(params[:code])

      if access_token_response && access_token_response['access_token']
        # Retrieve user PayPal info and save to database
        user_info = get_paypal_user_info(access_token_response['access_token'])
        current_user.update!(
          paypal_email: user_info['email'],
          paypal_merchant_id: user_info['payer_id'],
          paypal_access_token: access_token_response['access_token'],
          paypal_refresh_token: access_token_response['refresh_token']
        )

        redirect_to dashboard_path, notice: "PayPal account connected successfully."
      else
        redirect_to new_users_paypal_connects_path, alert: "Failed to connect PayPal account."
      end
    else
      redirect_to new_users_paypal_connects_path, alert: "Authorization failed or canceled."
    end
  end

  private

  def build_paypal_connect_url
    query_params = {
      flowEntry: 'static',
      client_id: PAYPAL_CLIENT_ID,
      scope: 'openid email profile https://uri.paypal.com/services/paypalattributes',
      redirect_uri: PAYPAL_REDIRECT_URI
    }
    "https://www.paypal.com/connect?#{query_params.to_query}"
  end

  def exchange_code_for_token(code)
    uri = URI("https://api-m.paypal.com/v1/oauth2/token")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(PAYPAL_CLIENT_ID, PAYPAL_SECRET)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.set_form_data(grant_type: 'authorization_code', code: code)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    Rails.logger.error "PayPal Token Exchange Failed: #{e.message}"
    nil
  end

  def get_paypal_user_info(access_token)
    uri = URI("https://api-m.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    Rails.logger.error "PayPal User Info Retrieval Failed: #{e.message}"
    nil
  end
end

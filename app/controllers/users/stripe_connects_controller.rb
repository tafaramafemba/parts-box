class Users::StripeConnectsController < ApplicationController
  before_action :authenticate_user!

  def new
    # Render a page where users can choose to create a new account or provide their existing Stripe account ID
  end

  def create_account
    # Create a new Stripe Connect account
    account = Stripe::Account.create({
      type: 'express',
      email: current_user.email,
    })
    current_user.update!(stripe_account_id: account.id)

    # Redirect to Stripe onboarding
    stripe_url = Stripe::AccountLink.create({
      account: account.id,
      refresh_url: new_users_stripe_connect_url,
      return_url: callback_users_stripe_connects_url,
      type: 'account_onboarding',
    }).url

    redirect_to stripe_url, allow_other_host: true
  end

  def connect_existing_account
    # Allow users to input their existing Stripe account ID
    if params[:stripe_account_id].present?
      current_user.update!(stripe_account_id: params[:stripe_account_id])

      redirect_to edit_account_settings_path, notice: "Your Stripe account was successfully connected."
    else
      redirect_to new_users_stripe_connect_url, alert: "Stripe Account ID cannot be blank."
    end
  end

  def disconnect_account
    current_user.update!(stripe_account_id: nil)

    redirect_to edit_account_settings_path, notice: "Stripe account disconnected successfully."
  end


  def callback
    # Handle the Stripe callback after account onboarding (optional)
    redirect_to edit_account_settings_path, notice: "Stripe account connected successfully."
  end
end


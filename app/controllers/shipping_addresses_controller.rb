class ShippingAddressesController < ApplicationController

  def new
    @shipping_address = current_user.build_shipping_address
  end

  def create
    @shipping_address = current_user.build_shipping_address(shipping_address_params)


    if @shipping_address.save
      redirect_to edit_account_settings_path, notice: 'Shipping address was successfully created.'
    else
      redirect_to edit_account_settings_path, alert: 'Shipping address could not be created.'
      Rails.logger.error @shipping_address.errors.full_messages
    end
  end

  def update
    @shipping_address = current_user.shipping_address || current_user.build_shipping_address
    if @shipping_address.update(shipping_address_params)
      redirect_to edit_account_settings_path, notice: 'Shipping address was successfully updated.'
    else
      redirect_to edit_account_settings_path, alert: 'Shipping address could not be updated.'

    end
  end

  def destroy
    @shipping_address.destroy
    redirect_to edit_account_settings_path, notice: 'Shipping address was successfully destroyed.'
  end

  private

  def set_shipping_address
    @shipping_address = current_user.shipping_address
  end

  def shipping_address_params
    params.require(:shipping_address).permit(
      :address_line1,
      :address_line2,
      :city,
      :state,
      :postal_code,
      :country
    )
  end
end


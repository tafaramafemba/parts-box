class UsersController < ApplicationController

  def edit
    @user = current_user
    @shipping_address = @user.shipping_address || @user.build_shipping_address
  end
end
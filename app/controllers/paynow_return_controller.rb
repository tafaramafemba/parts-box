class PaynowReturnController < ApplicationController
    def handle_return
      flash[:notice] = "Thank you for your payment! Your order is being processed."
      redirect_to root_path
    end
  end
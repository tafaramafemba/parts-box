class Admin::SellerInformationsController < ApplicationController
  def index
    @seller_informations = SellerInformation.all
  end

  def show
    @seller_information = SellerInformation.find(params[:id])
  end

  def update
    @seller_information = SellerInformation.find(params[:id])
    if @seller_information.status == 'active'
      @seller_information.update(status: 'suspended')
      @seller_information.user.update(seller_status: 'suspended')
      flash[:notice] = 'Seller suspended successfully.'
    elsif @seller_information.status == 'suspended'
      @seller_information.update(status: 'active')
      @seller_information.user.update(seller_status: 'approved')
      flash[:notice] = 'Seller activated successfully.'
    end
    redirect_to admin_seller_information_path(@seller_information)
  end
end

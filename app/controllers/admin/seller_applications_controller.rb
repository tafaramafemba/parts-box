class Admin::SellerApplicationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @seller_applications = SellerApplication.where(status: "pending")
  end

  def show
    @seller_application = SellerApplication.find(params[:id])
  end

  def update
    @seller_application = SellerApplication.find(params[:id])

    if params[:status] == "approved"
      @seller_application.update(status: "approved")
      @seller_application.user.update(seller_status: "approved")

      seller_information = SellerInformation.create(
        user: @seller_application.user,
        first_name: @seller_application.first_name,
        last_name: @seller_application.last_name,
        email: @seller_application.email,
        phone_number: @seller_application.phone_number,
        address: @seller_application.address,
        business_name: @seller_application.business_name,
        business_registration_number: @seller_application.business_registration_number,
      )
      # Attach ActiveStorage files
    seller_information.id_document.attach(@seller_application.id_document.blob) if @seller_application.id_document.attached?
    seller_information.business_registration_document.attach(@seller_application.business_registration_document.blob) if @seller_application.business_registration_document.attached?
    ApplicationApprovedMailer.approved(@seller_application.user, @seller_application).deliver_now

    elsif params[:status] == "rejected"
      @seller_application.update(status: "rejected")
      @seller_application.user.update(seller_status: "rejected")
      ApplicationRejectedMailer.rejected(@seller_application.user, @seller_application).deliver_now
    end

    redirect_to admin_seller_applications_path, notice: "Application updated successfully."
  end
end

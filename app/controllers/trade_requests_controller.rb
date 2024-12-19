class TradeRequestsController < ApplicationController
  def create
    @trade_request = TradeRequest.new(trade_request_params)
    @trade_request.sender_id = current_user.id # Assuming Devise or similar for authentication
    @trade_request.update(read: false)

    if @trade_request.save
      flash[:notice] = "Trade request sent successfully."
      redirect_to product_path(params[:trade_request][:product_id])
      @recipient = User.find(@trade_request.recipient_id)
      @product = Product.find(@trade_request.product_id)
      TradeRequestMailer.new_request(@recipient, current_user, @product).deliver_now
    else
      flash[:alert] = "Failed to send trade request."
      redirect_to product_path(params[:trade_request][:product_id])
    end
  end

  private

  def trade_request_params
    params.require(:trade_request).permit(
      :name,
      :make,
      :model,
      :year,
      :manufacturer_part_number,
      :condition,
      :location,
      :message,
      :cash_top_up,
      :product_id,
      :recipient_id,
      images: []
    )
  end
end


class OrderItemsController < ApplicationController
  def return
    @order_item = OrderItem.find(params[:id])
    @product = @order_item.product
    @seller_id = @product.user.id
    @seller = SellerInformation.find_by(user_id: @seller_id)
  end
end
# app/mailers/seller_mailer.rb
class SellerMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def order_placed(order, seller, order_item)
    @order = order
    @shipping_address = ShippingAddress.find(order.shipping_address_id)
    @seller = seller
    @order_item = order_item
    @product = order_item.product 

    mail(to: @seller.email, subject: "New Order Notification - Order ##{@order.id}")
  end

  def order_cancelled(order, seller, order_item)
    @order = order
    @seller = seller
    @order_item = order_item
    @product = order_item.product 

    mail(to: @seller.email, subject: "Order Cancellation Notification - Order ##{order.id}")
  end
end
# app/mailers/courier_mailer.rb
class CourierMailer < ApplicationMailer
    default from: 'notifications@example.com'
  
    def order_assigned(order)
      @order = order
      @courier = order.courier
      @shipping_address = ShippingAddress.find(order.shipping_address_id)
  
      mail(to: @courier.email, subject: "New Delivery Assignment - Order #PTG#{@order.id}")
    end
  end
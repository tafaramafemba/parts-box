# app/mailers/order_mailer.rb
class OrderMailer < ApplicationMailer
  def order_confirmation(order)
    @order = order
    @user = User.find(order.user_id)
    @order_items = OrderItem.where(order_id: order.id)

    mail(to: @user.email, subject: "Your Parts Box Order is Confirmed!")
  end

  def order_failure(order)
    @order = order
    @user = User.find(order.user_id)

    mail(to: @user.email, subject: "Your Parts Box Order Could Not Be Placed")
  end
end
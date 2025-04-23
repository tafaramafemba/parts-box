class PaynowWebhookController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def handle_notification
        reference = params[:reference]
        status = params[:status] # 'Paid', 'Cancelled', etc.
          
      if status == 'Paid'
        order = Order.find_by(reference: reference)
        if order && order.status == 'pending'
          # Update the order status to 'confirmed'
          order.update!(status: 'confirmed')
          OrderMailer.order_confirmation(order).deliver_now

          # Notify sellers about the order
          items_by_seller = order.order_items.group_by { |item| item.product.user }
          items_by_seller.each do |seller, items|
            SellerMailer.order_placed(order, seller, items).deliver_now
          end

  
          # Update stock for each order item
          order.order_items.each do |order_item|
            product = order_item.product
            product.update!(stock_quantity: product.stock_quantity - order_item.quantity)
            Cart.find_by(user_id: order.user_id).destroy
          end

  
          render plain: "OK", status: :ok
        else
          Rails.logger.error("Order not found or already processed for reference: #{status.reference}")
          render plain: "Order not found or already processed", status: :not_found
        end
      else
        Rails.logger.warn("Payment failed or pending for Order ##{status.reference}")
        render plain: "FAILED", status: :unprocessable_entity
      end
    end
  end
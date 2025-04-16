class PaynowWebhookController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def handle_notification
      status = PaynowClient.process_notification(params)
  
      if status.paid?
        order = Order.find_by(id: status.reference)
        if order && order.status == 'pending'
          # Update the order status to 'confirmed'
          order.update!(status: 'confirmed')
  
          # Update stock for each order item
          order.order_items.each do |order_item|
            product = order_item.product
            product.update!(stock_quantity: product.stock_quantity - order_item.quantity)
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
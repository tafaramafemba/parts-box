class StripeWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = env['ENDPOINT_SECRET']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: :bad_request and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: :bad_request and return
    end

    case event['type']
    when 'checkout.session.completed'
      session = event['data']['object']

      if session.payment_status == 'paid'
        handle_successful_payment(session)
      end
    else
      Rails.logger.info("Unhandled event type: #{event['type']}")
    end

    render json: { message: 'success' }, status: :ok
  end

  private

  def handle_successful_payment(session)
    order = Order.find_by(stripe_session_id: session.id)

    if order
      order.update!(status: 'confirmed')
      current_user.carts.destroy_all
      flash[:notice] = "Order confirmed. Your item is on its way!"
      OrderMailer.order_confirmation(order).deliver_now

      order.order_items.each do |order_item|
        product = order_item.product
        seller = product.user # Assuming 'user' is the seller of the product
  
        SellerMailer.order_placed(order, seller, order_item).deliver_now
      end

      Rails.logger.info("Order ##{order.id} confirmed after successful payment.")
    else
      Rails.logger.warn("Order with session ID #{session.id} not found.")
    end
  end
end

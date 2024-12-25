class StripeWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['ENDPOINT_SECRET']

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
      payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)
      charge_id = payment_intent.latest_charge # Retrieve the charge ID from the latest_charge field
      
      order.update!(status: 'confirmed')
      flash[:notice] = "Order confirmed. Your item is on its way!"
      OrderMailer.order_confirmation(order).deliver_now

      order.order_items.each do |order_item|
        product = order_item.product
        seller = product.user # Assuming 'user' is the seller of the product
        product.update!(stock_quantity: product.stock_quantity - order_item.quantity)
        Cart.find_by(user_id: order.user_id).destroy

        amount_cents = (order_item.quantity * product.price * 100).to_i
        shipping_fee_cents = (product.flat_rate_shipping_fee * 100).to_i

        Stripe::Transfer.create({
          amount: amount_cents + shipping_fee_cents,
          currency: 'cad',
          destination: product.user.stripe_account_id,
          transfer_group: "ORDER_#{order.id}",
          source_transaction: charge_id,
        })
  
        SellerMailer.order_placed(order, seller, order_item).deliver_now
      end

      Rails.logger.info("Order ##{order.id} confirmed after successful payment.")
    else
      Rails.logger.warn("Order with session ID #{session.id} not found.")
    end
  end
end

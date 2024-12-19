class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart_items = current_user.carts.includes(:product)
    @platform_fee = calculate_platform_fee(@cart_items)
    @shipping_fee = calculate_shipping_fee(@cart_items)
    @total_price = @cart_items.sum { |item| item.product.price * item.quantity } + @platform_fee + @shipping_fee
    @shipping_address = current_user.shipping_address || current_user.build_shipping_address
  end

  def create
    update_shipping_address
    cart_items = current_user.carts.includes(:product)
    platform_fee = calculate_platform_fee(cart_items)
    shipping_fee = calculate_shipping_fee(cart_items)
    total_price = cart_items.sum { |item| item.product.price * item.quantity } + platform_fee + shipping_fee
  
    payment_method = params[:payment_method]
  
    case payment_method
    when 'stripe'
      create_stripe_session(cart_items, total_price, platform_fee, shipping_fee)
      Rails.logger.info("Stripe payment initiated.")
    when 'paypal'
      create_paypal_order(cart_items, total_price, platform_fee, shipping_fee)
      Rails.logger.info("PayPal payment initiated.")
    else
      redirect_to carts_path, alert: "Invalid payment method selected."
    end
  end
  

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
    @shipping_address = ShippingAddress.find(@order.shipping_address_id)
  end

  def execute_paypal_payment
    payment_id = params[:paymentId]
    payer_id = params[:PayerID]

    payment = PayPal::SDK::REST::Payment.find(payment_id)

  begin
    if payment.execute(payer_id: payer_id)
      cart_items = current_user.carts.includes(:product)
      platform_fee = calculate_platform_fee(cart_items)
      shipping_fee = calculate_shipping_fee(cart_items)
      total_price = cart_items.sum { |item| item.product.price * item.quantity } + platform_fee + shipping_fee

      # Save orders and update stock
      order = Order.create!(
        user_id: current_user.id,
        total_price: total_price,
        platform_fee: platform_fee,
        shipping_fee: shipping_fee,
        status: 'pending', # Payment pending
        paypal_payment_id: payment.id, # Store payment ID
        )

      cart_items.each do |item|
        product = item.product
        OrderItem.create!(order_id: order.id, product_id: item.product.id, quantity: item.quantity)
        product.update!(stock_quantity: product.stock_quantity - item.quantity)
      end

      current_user.carts.destroy_all

      flash[:notice] = "Order confirmed. Your item is on its way!"

      redirect_to orders_path
    end

    rescue PayPal::SDK::Core::Exceptions::ConnectionError => e
      redirect_to carts_path, alert: "PayPal checkout failed: #{e.message}"
    end
  end

  def update_shipping_address
    if current_user.shipping_address.update(shipping_address_params)
    else
      flash[:alert] = "Failed to update shipping address."
    end
  end
  


  private

  def calculate_platform_fee(cart_items)
    cart_items.sum { |item| item.product.price * item.quantity } * 0.03
  end

  def calculate_shipping_fee(cart_items)
    cart_items.sum do |item|
      case item.product.shipping_fee_type
      when 'flat_rate'
        item.product.flat_rate_shipping_fee
      when 'calculated'
        # Add logic for calculated shipping (e.g., based on weight, dimensions, and destination)
        calculate_dynamic_shipping(item.product)
      when 'free'
        0
      else
        0
      end
    end
  end
  
  def calculate_dynamic_shipping(product)
    # Example: Placeholder logic, replace with integration to a shipping API
    weight_fee = product.weight * 2 # $2 per kg
    size_fee = product.dimensions.split('x').map(&:to_i).sum * 0.1 # $0.1 per cm of dimension sum
    weight_fee + size_fee
  end
  
  def create_stripe_session(cart_items, total_price, platform_fee, shipping_fee)
    begin
      # Calculate line items for Stripe session
      line_items = cart_items.map do |item|
        product_price_cents = (item.product.price * 100).to_i

        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: item.product.name,
            },
            unit_amount: product_price_cents,
          },
          quantity: item.quantity,
        }
      end

      # Add platform fee as a separate line item
      platform_fee_cents = (platform_fee * 100).to_i
      line_items << {
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Platform Fee',
          },
          unit_amount: platform_fee_cents
        },
        quantity: 1,
      }

      line_items << {
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Shipping Fee',
          },
          unit_amount: (shipping_fee * 100).to_i
        },
        quantity: 1,
      }

      # Create the Stripe session with payment split
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'payment',
        success_url: root_url + "?session_id={CHECKOUT_SESSION_ID}", # Use actual session ID
        cancel_url: root_url,
        payment_intent_data: {
          application_fee_amount: platform_fee_cents,
          transfer_data: {
            destination: current_user.stripe_account_id, # Assuming the user has a connected Stripe account
          },
        },
      })

      redirect_to session.url, allow_other_host: true 
      
      # Save orders and update stock
        order = Order.create!(
          user_id: current_user.id,
          total_price: total_price,
          platform_fee: platform_fee,
          shipping_fee: shipping_fee,
          status: 'pending', # Payment pending
          stripe_session_id: session.id, # Store session ID
          shipping_address_id: current_user.shipping_address.id
        )

        cart_items.each do |item|
          product = item.product
          OrderItem.create!(order_id: order.id, product_id: item.product.id, quantity: item.quantity)
          product.update!(stock_quantity: product.stock_quantity - item.quantity)
        end

    rescue Stripe::InvalidRequestError => e
      redirect_to carts_path, alert: "Stripe checkout failed: #{e.message}"
    end
  end
  
  def create_paypal_order(cart_items, total_price, platform_fee, shipping_fee)
    begin
      payment = PayPal::SDK::REST::Payment.new({
      intent: 'sale',
      payer: {
        payment_method: 'paypal'
      },
      redirect_urls: {
        return_url: execute_paypal_payment_url, # URL to handle payment success
        cancel_url: carts_url   # URL to handle payment cancellation
      },
      transactions: [{
        amount: {
        total: total_price.round(2).to_s,
        currency: 'USD',
        details: {
          subtotal: (total_price - platform_fee - shipping_fee).round(2).to_s,
          shipping: shipping_fee.round(2).to_s,
          handling_fee: platform_fee.round(2).to_s
        }
        },
        item_list: {
        items: cart_items.map do |item|
          {
          name: item.product.name,
          sku: "SKU-#{item.product.id}",
          price: item.product.price.to_s,
          currency: 'USD',
          quantity: item.quantity
          }
        end
        },
        description: "Purchase from Cart to Car"
      }]
      })
      
      if payment.create
      # Redirect user to PayPal for approval
      approval_url = payment.links.find { |link| link.rel == 'approval_url' }.href
      redirect_to approval_url, allow_other_host: true
      else
      redirect_to carts_path, alert: "PayPal checkout failed. Please try again."
      end
    rescue PayPal::SDK::Core::Exceptions::ConnectionError => e
      redirect_to carts_path, alert: "PayPal checkout failed: #{e.message}"
    end
  end
  
  def shipping_address_params
    params.require(:shipping_address).permit(:address_line1, :address_line2, :city, :state, :postal_code, :country)
  end
  
end



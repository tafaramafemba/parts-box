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
    when 'pickup'
      create_pickup_session(cart_items, total_price, platform_fee, shipping_fee)
    when 'cod'
      create_cod_session(cart_items, total_price, platform_fee, shipping_fee)
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
    @product = @order.order_items.first.product
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
    category_shipping_fees = {
      'Engine Components' => 10.0,
      'Transmission & Drivetrain' => 12.0,
      'Suspension & Steering' => 8.0,
      'Braking System' => 7.0,
      'Electrical & Lighting' => 5.0,
      'Exhaust System' => 9.0,
      'Cooling System' => 11.0,
      'Fuel System' => 6.0,
      'Interior Parts' => 4.0,
      'Exterior Parts' => 6.0,
      'Body Parts' => 15.0,
      'Wheels & Tires' => 14.0,
      'Heating, Ventilation & Air Conditioning (HVAC)' => 13.0,
      'Accessories' => 3.0,
      'Performance Parts' => 20.0
    }

    highest_shipping_fee = cart_items.map do |item|
      category_shipping_fees[item.product.category] || 0
    end.max

    highest_shipping_fee
  end
  
  def calculate_dynamic_shipping(product)
    # Example: Placeholder logic, replace with integration to a shipping API
    weight_fee = product.weight * 2 # $2 per kg
    size_fee = product.dimensions.split('x').map(&:to_i).sum * 0.1 # $0.1 per cm of dimension sum
    weight_fee + size_fee
  end
  
  def create_stripe_session(cart_items, total_price, platform_fee, shipping_fee)
    begin
      # Calculate line items without transfer_data
      line_items = cart_items.map do |item|
        product_price_cents = (item.product.price * 100).to_i
        shipping_cents = (item.product.flat_rate_shipping_fee * 100).to_i
        total_cents = product_price_cents + shipping_cents
  
        {
          price_data: {
            currency: 'cad',
            product_data: {
              name: item.product.name + ' (Shipping Incl)'
            },
            unit_amount: total_cents,
          },
          quantity: item.quantity
        }
      end

      line_items << {
        price_data: {
          currency: 'cad',
          product_data: {
            name: 'Platform Fee'
          },
          unit_amount: (platform_fee * 100).to_i,
        },
        quantity: 1
      }
  
      # Save the order
      order = Order.create!(
        user_id: current_user.id,
        total_price: total_price,
        platform_fee: platform_fee,
        shipping_fee: shipping_fee,
        status: 'pending', # Payment pending
        stripe_session_id: nil,
        shipping_address_id: current_user.shipping_address.id
      )
  
      cart_items.each do |item|
        OrderItem.create!(order_id: order.id, product_id: item.product.id, quantity: item.quantity)
      end
  
      # Create Stripe Checkout Session
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'payment',
        success_url: root_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: root_url,
        payment_intent_data: {
          transfer_group: "ORDER_#{order.id}"
        }
      })
  
      # Update order with Stripe session ID
      order.update!(stripe_session_id: session.id)
  
      # Redirect to Stripe checkout
      redirect_to session.url, allow_other_host: true
  
    rescue Stripe::InvalidRequestError => e
      redirect_to carts_path, alert: "Stripe checkout failed: #{e.message}"
    end
  end

  
  def shipping_address_params
    params.require(:shipping_address).permit(:address_line1, :address_line2, :city, :state, :postal_code, :country)
  end

  def create_cod_session(cart_items, total_price, platform_fee, shipping_fee)
    # Save the order
    order = Order.create!(
      user_id: current_user.id,
      total_price: total_price,
      platform_fee: platform_fee,
      shipping_fee: shipping_fee,
      status: 'pending', # Payment pending
      shipping_address_id: current_user.shipping_address.id
    )

    cart_items.each do |item|
      product = item.product
      seller = product.user # Assuming 'user' is the seller of the product
      OrderItem.create!(order_id: order.id, product_id: item.product.id, quantity: item.quantity)
      product.update!(stock_quantity: product.stock_quantity - item.quantity)
      SellerMailer.order_placed(order, seller, item).deliver_now
    end

    current_user.carts.destroy_all

    flash[:notice] = "Order confirmed. Your item is on its way!"
    OrderMailer.order_confirmation(order).deliver_now
    whatsapp_notification(order, total_price)

    redirect_to orders_path

  end

  def create_pickup_session(cart_items, total_price, platform_fee, shipping_fee)
    # Save the order
    order = Order.create!(
      user_id: current_user.id,
      total_price: total_price,
      platform_fee: platform_fee,
      shipping_fee: shipping_fee,
      status: 'pending', # Payment pending
      shipping_address_id: current_user.shipping_address.id
    )

    cart_items.each do |item|
      product = item.product
      seller = product.user # Assuming 'user' is the seller of the product
      OrderItem.create!(order_id: order.id, product_id: item.product.id, quantity: item.quantity)
      product.update!(stock_quantity: product.stock_quantity - item.quantity)
      SellerMailer.order_placed(order, seller, item).deliver_now
    end

    current_user.carts.destroy_all

    flash[:notice] = "Order confirmed. Please pick up your items at the designated location within 24 hours."
    OrderMailer.order_confirmation(order).deliver_now
    pickup_whatsapp_notification(order, total_price)

    redirect_to orders_path
  end




  def whatsapp_notification(order, total_price)
    seller_id = order.order_items.first.product.user_id
    sellerInformation = SellerInformation.find_by(user_id: seller_id)
    seller_phone_number = sellerInformation.phone_number
    instance_id = ENV['ULTRAMSG_INSTANCE_ID']
    token = ENV['ULTRAMSG_TOKEN']
    service = UltraMsgService.new(instance_id, token)
    total_price_dollars = ActionController::Base.helpers.number_to_currency(total_price)
    message = "Your order on Parts Box has been confirmed. Order number PB#{order.id}. Your order will arrive by the end of the day. Please have #{total_price_dollars} ready for payment upon arrival. You can cancel within an hour of ordering on our platform. Failure to do so will result in platform and delivery fees. Thank you for shopping with us!"
    messagetwo = "An order has been placed for your item on Parts Box. Order number PB#{order.id}. Please prepare the item(s) for shipment. Thank you for using Parts Box!"

    response = service.send_message(current_user.phone_number, message)
    responsetwo = service.send_message(seller_phone_number, messagetwo)
    if response["sent"]
      Rails.logger.info("Message sent to #{current_user.phone_number}")
    else
      Rails.logger.error("Failed to send message: #{response['error']}")
    end
  end

  def pickup_whatsapp_notification(order, total_price)
    seller_id = order.order_items.first.product.user_id
    sellerInformation = SellerInformation.find_by(user_id: seller_id)
    seller_phone_number = sellerInformation.phone_number
    instance_id = ENV['ULTRAMSG_INSTANCE_ID']
    token = ENV['ULTRAMSG_TOKEN']
    service = UltraMsgService.new(instance_id, token)
    total_price_dollars = ActionController::Base.helpers.number_to_currency(total_price)
    message = "Your order on Parts Box has been confirmed. Your order number is PB#{order.id}. Please pick up your order at our pickup location within 24 hours. Please note that your order will be cancelled if it is not collected by then. Please kindly have the exact amount of #{total_price_dollars} upon collection of the order. For more information, please contact us at 123-456-7890. Thank you for shopping with us!"
    messagetwo = "An order has been placed for your item on Parts Box. Order number PB#{order.id}. Please prepare the item(s) for shipment. Thank you for using Parts Box!"

    response = service.send_message(current_user.phone_number, message)
    responsetwo = service.send_message(seller_phone_number, messagetwo)
    if response["sent"]
      Rails.logger.info("Message sent to #{current_user.phone_number}")
    else
      Rails.logger.error("Failed to send message: #{response['error']}")
    end
  end
  
end


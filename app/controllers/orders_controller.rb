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
    total_price_pickup = cart_items.sum { |item| item.product.price * item.quantity } + platform_fee
  
    payment_method = params[:payment_method]
  
    case payment_method
    when 'pickup'
      create_pickup_session(cart_items, total_price_pickup, platform_fee, shipping_fee = 0)
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
    if current_user.shipping_address.present?
      current_user.shipping_address.update(shipping_address_params)
    else
      current_user.create_shipping_address(shipping_address_params)
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Failed to update shipping address: #{e.message}"
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.update!(status: 'cancelled')
    
    order.order_items.each do |order_item|
      product = order_item.product
      product.update!(stock_quantity: product.stock_quantity + order_item.quantity)
      SellerMailer.order_cancelled(order, product.user, order_item ).deliver_now
    end
    OrderMailer.order_cancellation(order).deliver_now
    flash[:notice] = "Order cancelled successfully."
    redirect_to orders_path
  end


  


  private

  def calculate_platform_fee(cart_items)
    platform_fee_percentage = PlatformFee.first&.percentage || 0.03
    fee = cart_items.sum { |item| item.product.price * item.quantity } * platform_fee_percentage
    rounded_fee = (fee / 1).ceil * 1
    rounded_fee
  end

  def calculate_shipping_fee(cart_items)
    category_shipping_fees = CategoryShippingFee.all.index_by(&:category)
    
    highest_shipping_fee = cart_items.map do |item|
      category_shipping_fees[item.product.category]&.fee || 0
    end.max
  
    highest_shipping_fee
  end

  
  def shipping_address_params
    params.require(:shipping_address).permit(:address_line1, :address_line2, :city, :state)
  end

  def create_cod_session(cart_items, total_price, platform_fee, shipping_fee)
    # Save the order
    order = Order.create!(
      user_id: current_user.id,
      total_price: total_price,
      platform_fee: platform_fee,
      shipping_fee: shipping_fee,
      status: 'pending', # Payment pending
      shipping_address_id: current_user.shipping_address.id,
      collection_method: 'delivery'
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

  def create_pickup_session(cart_items, total_price_pickup, platform_fee, shipping_fee = 0)
    # Save the order
    order = Order.create!(
      user_id: current_user.id,
      total_price: total_price_pickup,
      platform_fee: platform_fee,
      shipping_fee: shipping_fee,
      status: 'pending', # Payment pending
      shipping_address_id: current_user.shipping_address.id,
      collection_method: 'pickup'
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
    pickup_whatsapp_notification(order, total_price_pickup)

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
    message = "Your order on Parts Box has been confirmed. Order number PB#{order.id}. Your order will arrive soon. Please have #{total_price_dollars} ready for payment upon arrival. You can cancel within an hour of ordering on our platform. Failure to do so will result in mandatory delivery charges. Thank you for shopping with us!"
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
    message = "Your order on Parts Box has been confirmed. Your order number is PB#{order.id}. Your order will be available for collection at #{order.collection_time} . Please pick up your order at our pickup location within 24 hours. Please note that your order will be cancelled if it is not collected by then. Please kindly have the exact amount of #{total_price_dollars} upon collection of the order. For more information, please contact us at 123-456-7890. Thank you for shopping with us!"
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


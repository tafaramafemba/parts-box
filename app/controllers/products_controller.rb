class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
    @products = @products.joins(:user).where.not(users: { seller_status: 'suspended' })
    @trade_requests = TradeRequest.where(recipient_id: current_user.id)
    @unread_count = @trade_requests.where(read: false).count
    @chats = Chat.where("buyer_id = ? OR seller_id = ?", current_user.id, current_user.id)
    @unread_chats = @chats.where(read: false).count
    @orders = Order.where(user_id: current_user.id, status: 'pending')
    @orders_count = @orders.count


  
    # Filter by name
    if params[:query].present?
      @products = @products.where("name LIKE ?", "%#{params[:query]}%")
    end
  
    # Filter by type (for sale or barter)
    if params[:filter_type].present? && params[:filter_type] != 'all'
      if params[:filter_type] == 'sale'
        @products = @products.where.not(price: nil) # Products with a price are "for sale"
      elsif params[:filter_type] == 'barter'
        @products = @products.where.not(barter_terms: nil) # Products with barter terms
      end
    end
  
    # Filter by price (budget)
    if params[:min_price].present? && params[:max_price].present?
      min_price = params[:min_price].to_f
      max_price = params[:max_price].to_f
      @products = @products.where(price: min_price..max_price)
    end

    if params[:location].present?
      @products = @products.where(location: params[:location])
    end
  end
  
  def show
    @chat = Chat.find_by(product_id: @product.id, buyer_id: current_user.id) # Check if a chat exists
    
    if @chat.nil?
      @chat = Chat.create!(product: @product, buyer: current_user, seller: @product.user)
    end
    
    @messages = @chat.messages
    @product = Product.find(params[:id])
    @seller = @product.user
  end
  

  def new
    @product = Product.new
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
      Rails.logger.info("Product Params: #{product_params}")
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def create
    @product = current_user.products.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def my_listings
    @products = current_user.products

    # Search filter
    if params[:query].present?
      @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :barter_terms, :image, :location, :make, :model, :year, :stock_quantity, :manufacturer_part_number, :condition, :shipping_fee_type, :flat_rate_shipping_fee, :weight, :dimensions, :shipping_address, additional_images: [])
  end
end

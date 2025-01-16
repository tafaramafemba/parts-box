class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy delist relist]

  def index
    @products = Product.where(listing_status: true)
    @products = @products.joins(:user).where.not(users: { seller_status: 'suspended' })
    if current_user
      @orders = Order.where(user_id: current_user.id, status: 'pending')
      @orders_count = @orders.count
    else
      @orders = []
      @orders_count = 0
    end

    # Filter by name
    if params[:query].present?
      @products = @products.where("name LIKE ?", "%#{params[:query]}%")
    end
  
    # Filter by price (budget)
    if params[:min_price].present? && params[:max_price].present?
      min_price = params[:min_price].to_f
      max_price = params[:max_price].to_f
      @products = @products.where(price: min_price..max_price)
    end

    # Filter by location
    if params[:location].present?
      @products = @products.where(location: params[:location])
    end

    # Filter by make
    if params[:make].present?
      @products = @products.where(make: params[:make])
    end

    # Filter by model
    if params[:model].present?
      @products = @products.where(model: params[:model])
    end

    # Filter by year
    if params[:year].present?
      @products = @products.where(year: params[:year])
    end

    # Filter by manufacturer part number
    if params[:manufacturer_part_number].present?
      @products = @products.where(manufacturer_part_number: params[:manufacturer_part_number])
    end

    @products = @products.page(params[:page]).per(20)
  end

  def show
    
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
      redirect_to my_listings_products_path, notice: 'Product was successfully created.'
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

  def delist
    @product.update(listing_status: false)
    redirect_to my_listings_products_path, notice: 'Product was successfully delisted.'
  end

  def relist
    @product.update(listing_status: true)
    redirect_to my_listings_products_path, notice: 'Product was successfully relisted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :barter_terms, :image, :location, :category, :make, :model, :year, :stock_quantity, :manufacturer_part_number, :condition, :shipping_fee_type, :flat_rate_shipping_fee, :weight, :dimensions, :shipping_address, additional_images: [])
  end
end

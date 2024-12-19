class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.carts.includes(:product)
    @total_price = @cart_items.sum(&:total_price)
  end

  def create
    cart_item = current_user.carts.find_or_initialize_by(product_id: params[:product_id])
    cart_item.quantity = params[:quantity].to_i
    if cart_item.save
      redirect_to carts_path, notice: "Item added to cart."
    else
      redirect_to product_path(params[:product_id]), alert: "Could not add item to cart."
    end
  end

  def update
    cart_item = current_user.carts.find(params[:id])
    cart_item.update(quantity: params[:quantity].to_i)
    redirect_to carts_path, notice: "Cart updated."
  end

  def destroy
    cart_item = current_user.carts.find(params[:id])
    cart_item.destroy
    redirect_to carts_path, notice: "Item removed from cart."
  end
end

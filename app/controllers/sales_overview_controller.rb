class SalesOverviewController < ApplicationController
    def index
      @products = current_user.products
      @total_sales = @products.joins(:order_items).sum('order_items.quantity * products.price')
      @total_orders = Order.where(user_id: current_user.id).count
      @total_revenue = Order.where(status: 'delivered', user_id: current_user.id).sum(:total_price)
      @average_order_value = @total_orders > 0 ? @total_revenue / @total_orders : 0
      @top_selling_products = @products.joins(:order_items).group('products.id').order('SUM(order_items.quantity) DESC').limit(5)
    end
  end
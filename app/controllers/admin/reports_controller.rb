class Admin::ReportsController < Admin::BaseController
  def index
    @total_orders = Order.count
    @completed_orders = Order.where(status: 'delivered').count
    @total_revenue = Order.where(status: 'delivered').sum(:total_price)
    @potential_revenue = Order.where.not(status: 'delivered').sum(:total_price)
    @total_customers = User.count
    @orders_by_status = Order.group(:status).count
    @orders_by_date = Order.group_by_day(:created_at, time_zone: false).count
    @product_sales = OrderItem.joins(:product).group('products.name').sum('order_items.quantity')
    @revenue_by_product = OrderItem.joins(:product).group('products.name').sum('order_items.quantity * products.price')
    @payouts_by_seller = PayoutTransaction.joins(:user).group('users.email').sum(:amount)
    @active_sellers = User.joins(:products).distinct.count
    @top_performing_categories = Product.joins(:order_items).group('products.category').order('SUM(order_items.quantity) DESC').limit(5).pluck('products.category')
    @average_order_value = @total_revenue / @completed_orders.to_f
    @new_sellers_onboarded = User.where('created_at >= ?', 1.month.ago).count
    @new_buyers_registered = User.where('created_at >= ?', 1.month.ago).count

    
    # Calculate commission and platform fees
    commission_percentage = CommissionFee.first&.percentage || 0.05
    platform_percentage = PlatformFee.first&.percentage || 0.03

    @total_commission_fees = Order.where(status: 'delivered').sum { |order| order.total_price * commission_percentage }
    @total_platform_fees = Order.where(status: 'delivered').sum { |order| order.total_price * platform_percentage }

    @sales_volume_by_category = Product.joins(:order_items).group('products.category').sum('order_items.quantity * products.price')
  end
end
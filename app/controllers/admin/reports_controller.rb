class Admin::ReportsController < Admin::BaseController
    def index
      @total_orders = Order.count
      @total_revenue = Order.sum(:total_price)
      @total_customers = User.count
      @orders_by_status = Order.group(:status).count
      @orders_by_date = Order.group_by_day(:created_at, time_zone: false).count
    end
  end

class Admin::OrdersController < Admin::BaseController
    before_action :authenticate_admin!

    def index
        @orders = Order.all
    
        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date])
          end_date = Date.parse(params[:end_date])
          @orders = @orders.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
        end
    
        @orders = @orders.where(status: params[:status]) if params[:status].present?
    
        respond_to do |format|
          format.html
          format.csv { send_data @orders.to_csv, filename: "orders-#{Date.today}.csv" }
        end
    end


    
    def show
      @order = Order.find(params[:id])
      @commission_fee = calculate_commission_fee(@order.order_items)
      @platform_fee = @order.platform_fee
      @shipping_fee = @order.shipping_fee
      @subtotal = @order.order_items.sum { |item| item.product.price * item.quantity }
      @total_price = @order.total_price 
      @amount_due_to_seller = @subtotal - @commission_fee
    end

    def update_status
    @order = Order.find(params[:id])
    if @order.update(order_params)
        flash[:notice] = "Order status updated successfully."
        mark_as_delivered if @order.status == 'delivered' || @order.status == 'completed'
    else
        flash[:alert] = "Failed to update order status."
    end
    redirect_to admin_order_path(@order)
    end


    def calculate_commission_fee(cart_items)
      commission_fee_percentage = CommissionFee.first&.percentage || 0.05
      fee = cart_items.sum { |item| item.product.price * item.quantity } * commission_fee_percentage
      rounded_fee = (fee / 1).ceil * 1
      rounded_fee
    end
    

    private

    def mark_as_delivered
      @order.order_items.each do |item|
        seller_balance = SellerBalance.find_or_create_by(user: item.product.user)
        Rails.logger.info "Seller balance: #{seller_balance.inspect}"
        seller_balance.update(balance: seller_balance.balance + item.amount_due_to_seller)
      end
    end

    def order_params
    params.require(:order).permit(:status)
    end
end
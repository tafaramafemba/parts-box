
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
    end

    def update_status
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
        flash[:notice] = "Order status updated successfully."
    else
        flash[:alert] = "Failed to update order status."
    end
    redirect_to admin_order_path(@order)
    end

    private

    def order_params
    params.require(:order).permit(:status)
    end
end

class Admin::OrdersController < ApplicationController
    before_action :authenticate_admin!

    def index
    @orders = Order.order(created_at: :desc)
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
class Admin::DeliveriesController < Admin::BaseController
  before_action :authenticate_admin!

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @deliveries = Order.where(delivery_slot: @date.beginning_of_day..@date.end_of_day)
                       .where.not(collection_method: 'pickup')
    @deliveries = @deliveries.where(status: params[:status]) if params[:status].present?
    if params[:search].present?
      @deliveries = @deliveries.joins(:user).where("orders.id = ? OR users.email ILIKE ?", params[:search], "%#{params[:search]}%")
    end
    @deliveries = @deliveries.order(:delivery_slot)
  
    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv, filename: "deliveries-#{@date}.csv" }
    end
  end

  def export_slot
    slot_time = params[:slot_time]
    Rails.logger.debug "Exporting orders for slot time: #{slot_time}"
    @orders = Order.where("strftime('%H:%M', delivery_slot) = ?", slot_time)
    respond_to do |format|
      format.csv { send_data @orders.to_csv_for_slot(slot_time), filename: "deliveries-#{slot_time}.csv" }
    end
  end

  def mark_as_completed
    @order = Order.find(params[:id])
    if @order.update(status: :delivered)
      flash[:notice] = "Order marked as completed."
    else
      flash[:alert] = "Failed to mark order as completed."
    end
    redirect_to admin_deliveries_path(date: params[:date])
  end

  def mark_as_not_completed
    @order = Order.find(params[:id])
    if @order.update(status: :delivery_failed)
      flash[:notice] = "Order marked as not completed."
    else
      flash[:alert] = "Failed to mark order as not completed."
    end
    redirect_to admin_deliveries_path(date: params[:date])
  end
end

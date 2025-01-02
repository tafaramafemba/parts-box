class Admin::DeliverySlotsController < ApplicationController
    before_action :authenticate_admin!

    def index
        @delivery_slots = DeliverySlot.all
    end

    def new
        @delivery_slot = DeliverySlot.new
    end

    def create
        @delivery_slot = DeliverySlot.new(delivery_slot_params)
        if @delivery_slot.save
        flash[:notice] = "Delivery slot created successfully."
        redirect_to admin_delivery_slots_path
        else
        flash[:alert] = "Failed to create delivery slot."
        render :new
        end
    end

    def edit
        @delivery_slot = DeliverySlot.find(params[:id])
    end

    def update
        @delivery_slot = DeliverySlot.find(params[:id])
        if @delivery_slot.update(delivery_slot_params)
        flash[:notice] = "Delivery slot updated successfully."
        redirect_to admin_delivery_slots_path
        else
        flash[:alert] = "Failed to update delivery slot."
        render :edit
        end
    end

    def destroy
        @delivery_slot = DeliverySlot.find(params[:id])
        @delivery_slot.destroy
        flash[:notice] = "Delivery slot deleted successfully."
        redirect_to admin_delivery_slots_path
    end

    private

    def delivery_slot_params
        params.require(:delivery_slot).permit(:time, :cutoff)
    end
end
# app/controllers/admin/couriers_controller.rb
class Admin::CouriersController < Admin::BaseController
  before_action :set_courier, only: [:show, :edit, :update, :destroy]

  def index
    @couriers = Courier.all
  end

  def show
  end

  def new
    @courier = Courier.new
  end

  def edit
  end

  def create
    @courier = Courier.new(courier_params)
    if @courier.save
      redirect_to admin_courier_path(@courier), notice: 'Courier was successfully created.'
    else
      render :new
    end
  end

  def update
    if @courier.update(courier_params)
      redirect_to admin_courier_path(@courier), notice: 'Courier was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @courier.destroy
    redirect_to admin_couriers_path, notice: 'Courier was successfully deleted.'
  end

  private

  def set_courier
    @courier = Courier.find(params[:id])
  end

  def courier_params
    params.require(:courier).permit(:name, :email, :phone_number)
  end
end

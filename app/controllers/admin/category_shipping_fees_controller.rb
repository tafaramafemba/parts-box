class Admin::CategoryShippingFeesController < Admin::BaseController
    before_action :set_category_shipping_fee, only: [:edit, :update, :destroy]
  
    def index
      @category_shipping_fees = CategoryShippingFee.all
    end
  
    def new
      @category_shipping_fee = CategoryShippingFee.new
    end
  
    def create
      @category_shipping_fee = CategoryShippingFee.new(category_shipping_fee_params)
      if @category_shipping_fee.save
        redirect_to admin_category_shipping_fees_path, notice: 'Category shipping fee was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @category_shipping_fee.update(category_shipping_fee_params)
        redirect_to admin_category_shipping_fees_path, notice: 'Category shipping fee was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @category_shipping_fee.destroy
      redirect_to admin_category_shipping_fees_path, notice: 'Category shipping fee was successfully destroyed.'
    end
  
    private
  
    def set_category_shipping_fee
      @category_shipping_fee = CategoryShippingFee.find(params[:id])
    end
  
    def category_shipping_fee_params
      params.require(:category_shipping_fee).permit(:category, :fee)
    end
  end
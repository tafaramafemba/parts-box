class Admin::CommissionFeesController < Admin::BaseController
    before_action :set_commission_fee, only: [:edit, :update]
  
    def index
      @commission_fee = CommissionFee.first_or_initialize
    end
  
    def edit
    end
  
    def update
      if @commission_fee.update(commission_fee_params)
        redirect_to admin_commission_fees_path, notice: 'Commission fee was successfully updated.'
      else
        render :edit
      end
    end
  
    private
  
    def set_commission_fee
      @commission_fee = CommissionFee.find(params[:id])
    end
  
    def commission_fee_params
      params.require(:commission_fee).permit(:percentage)
    end
  end
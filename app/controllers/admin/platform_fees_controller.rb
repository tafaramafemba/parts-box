class Admin::PlatformFeesController < Admin::BaseController
    before_action :set_platform_fee, only: [:edit, :update]
  
    def index
      @platform_fee = PlatformFee.first_or_initialize
    end
  
    def edit
    end
  
    def update
      if @platform_fee.update(platform_fee_params)
        redirect_to admin_platform_fees_path, notice: 'Platform fee was successfully updated.'
      else
        render :edit
      end
    end
  
    private
  
    def set_platform_fee
      @platform_fee = PlatformFee.find(params[:id])
    end
  
    def platform_fee_params
      params.require(:platform_fee).permit(:percentage)
    end
  end

class Admin::PayoutsController < Admin::BaseController
  include ActionView::Helpers::NumberHelper

    def index
      @sellers = User.joins(:seller_balance).where.not(seller_balances: { balance: 0 })
    end
  
    def show
      @seller = User.find(params[:id])
      @balance = @seller.seller_balance.balance
    end

    def send_otp
      @seller = User.find(params[:id])
      otp = SecureRandom.random_number(1000..9999) # Generates a 4-digit code
      session[:otp] = otp
  
      # Send the OTP via WhatsApp
      send_whatsapp_message(@seller.phone_number, "Your OTP for payout is: #{otp}")
      Rails.logger.info("OTP sent to seller: #{otp}")
  
      render json: { status: "OTP sent" }
    end
  
    def verify_otp
      @seller = User.find(params[:id])
      submitted_otp = params[:otp].to_i
  
      if submitted_otp == session[:otp]
        payout(@seller)
        render json: { status: "success", message: "Payout completed successfully." }
      else
        render json: { status: "failed", message: "Invalid OTP." }, status: :unprocessable_entity
      end
    end
  
    def payout(seller)
      @balance = seller.seller_balance.balance
  
      if @balance > 0
        seller.seller_balance.update(balance: 0)
        flash[:notice] = "Payout of #{number_to_currency(@balance)} to #{@seller.email} completed."
      else
        flash[:alert] = "No balance available for payout."
      end
      end

    def send_whatsapp_message(phone_number, message)
      instance_id = ENV['ULTRAMSG_INSTANCE_ID']
      token = ENV['ULTRAMSG_TOKEN']
      service = UltraMsgService.new(instance_id, token)
  
      response = service.send_message(phone_number, message)
      if response["sent"]
        Rails.logger.info("Message sent to #{phone_number}")
      else
        Rails.logger.error("Failed to send message: #{response['error']}")
      end
    end
  end
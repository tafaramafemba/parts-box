class InboxController < ApplicationController
  def index
    @trade_requests = TradeRequest.where(recipient_id: current_user.id).order(created_at: :desc)
    @unread_count = @trade_requests.where(read: false).count
  end

  def show
    @trade_request = TradeRequest.find(params[:id])
    
    # Mark the trade request as read
    @trade_request.update(read: true) unless @trade_request.read
  end
  
end

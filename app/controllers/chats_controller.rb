class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch all chats where the current user is either the buyer or seller
    @chats = Chat.where("buyer_id = ? OR seller_id = ?", current_user.id, current_user.id)
  end

  def create
    @chat = Chat.find_or_create_by(
      buyer_id: current_user.id,
      seller_id: params[:seller_id],
      product_id: params[:product_id]
    )
  end

  def show
    @chat = Chat.includes(:messages).find(params[:id])
    @messages = @chat.messages
  end
end

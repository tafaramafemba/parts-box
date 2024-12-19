class ChatsController < ApplicationController
  before_action :authenticate_user!

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

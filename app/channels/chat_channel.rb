class ChatChannel < ApplicationCable::Channel
  def subscribed
    logger.debug "Subscribed to chat_#{params[:chat_id]}"
    stream_from "chat_#{params[:chat_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

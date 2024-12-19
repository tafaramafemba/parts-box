class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(message_params.merge(sender: current_user))

    if @message.save
      # Message will be broadcast automatically by `after_create_commit` callback
    else
      render turbo_stream: turbo_stream.replace("message-form", partial: "shared/errors", locals: { errors: @message.errors })
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end


class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: 'User'

  after_create_commit do
    ActionCable.server.broadcast("chat_#{chat_id}", render_message(self))
  end
  
  private
  
  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
  
end
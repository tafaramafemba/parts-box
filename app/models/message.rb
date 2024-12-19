class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: 'User'

  after_create_commit do
    broadcast_append_to "chat_#{chat_id}", target: "messages", partial: "messages/message", locals: { message: self }
  end
end
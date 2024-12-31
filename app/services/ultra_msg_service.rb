# app/services/ultra_msg_service.rb
require 'http'

class UltraMsgService
  BASE_URL = "https://api.ultramsg.com"

  def initialize(instance_id, token)
    @instance_id = instance_id
    @token = token
  end

  def send_message(phone, message)
    response = HTTP.post("#{BASE_URL}/#{@instance_id}/messages/chat", 
      json: {
        token: @token,
        to: phone,
        body: message
      }
    )
    JSON.parse(response.body.to_s)
  rescue => e
    Rails.logger.error("UltraMsg Error: #{e.message}")
    { error: e.message }
  end
end
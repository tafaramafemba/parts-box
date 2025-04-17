require 'httparty'
require 'digest'
require 'cgi'


class PaynowService
  PAYNOW_URL = 'https://www.paynow.co.zw/Interface/initiateTransaction'.freeze

  def initialize(return_url:, result_url:)
    @integration_id = ENV['PAYNOW_INTEGRATION_ID']
    @integration_key = ENV['PAYNOW_INTEGRATION_KEY']
    @return_url = return_url
    @result_url = result_url
  end

  def create_payment(reference:, amount:, email:)
    params = {
      id: @integration_id,
      reference: reference,
      amount: amount,
      additionalinfo: "Payment for #{reference}",
      returnurl: @return_url,
      resulturl: @result_url,
      authemail: 'apps@todazimbabwe.com',
      status: 'Message'
    }

    # Generate the hash
    params[:hash] = generate_hash(params)

    headers = {
    'Content-Type' => 'application/x-www-form-urlencoded',
    'Accept' => 'application/x-www-form-urlencoded'
    }

    response = HTTParty.post(PAYNOW_URL, body: params, headers: headers)


    parsed = Rack::Utils.parse_nested_query(response.body)
    Rails.logger.debug "Paynow Raw Response: #{response.body}"

    if parsed['status'] == 'Ok' && parsed['browserurl']
      {
        success: true,
        browser_url: parsed['browserurl'],
        poll_url: parsed['pollurl']
      }
    else
      {
        success: false,
        error: parsed['error'] || 'Unknown error',
        response: parsed
      }
    end
  end

  private

  def generate_hash(params)
    data = [
      params[:id].to_s,
      params[:reference].to_s,
      params[:amount].to_s,
      params[:additionalinfo].to_s,
      params[:returnurl].to_s,
      params[:resulturl].to_s,
      params[:authemail].to_s,
      params[:status].to_s
    ].join
  
    Rails.logger.debug "Hash String: #{data + @integration_key}"
    Rails.logger.debug "Generated Hash: #{Digest::SHA512.hexdigest(data + @integration_key)}"
    Rails.logger.debug "Integration ID: #{@integration_id}"
    Rails.logger.debug "Integration Key: #{@integration_key}"

  
    Digest::SHA512.hexdigest(data + @integration_key).upcase
  end
end

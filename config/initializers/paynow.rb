require 'paynow_sdk'

PaynowClient = Paynow.new(
  ENV['PAYNOW_INTEGRATION_ID'],  # Your Paynow Integration ID
  ENV['PAYNOW_INTEGRATION_KEY'], # Your Paynow Integration Key
  ENV['PAYNOW_RETURN_URL'],      # URL to redirect the user after payment
  ENV['PAYNOW_RESULT_URL']       # URL for Paynow payment notifications
)
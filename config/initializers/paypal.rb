PayPal::SDK::REST.set_config(
  mode: "sandbox", # "sandbox" for testing or "live" for production
  client_id: ENV['PAYPAL_CLIENT_ID'], # Replace with your PayPal Client ID
  client_secret: ENV['PAYPAL_CLIENT_SECRET'], # Replace with your PayPal Client Secret
  ssl_options: { ca_file: nil }
)

require_relative "boot"

require "rails/all"
require 'http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CarPartsPlatform
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2


    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.time_zone = 'Harare' # Harare is in the CAT time zone
    # config/application.rb

    config.action_cable.mount_path = '/cable'
    config.action_cable.disable_request_forgery_protection = true

    # config.eager_load_paths << Rails.root.join("extras")
  end
end

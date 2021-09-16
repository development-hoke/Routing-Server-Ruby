require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module OneDateServer
  class Application < Rails::Application
    # API Mode
    config.api_only = true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # default language
    config.i18n.default_locale = :ja
    # Time zone
    config.time_zone = ENV["TZ"]
    config.active_record.default_timezone = :local
  end
end

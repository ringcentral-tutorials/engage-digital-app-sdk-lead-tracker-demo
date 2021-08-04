require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LeadTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_dispatch.cookies_same_site_protection = :none

    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: ENV['MAILGUN_API_KEY'],
      domain: ENV['MAILGUN_DOMAIN'],
    }

    def ed_domain_name
      ENV['ED_DOMAIN_NAME']
    end

    def ed_hostname
      ENV.fetch('ED_HOSTNAME', 'digital.ringcentral.com')
    end

    def ed_api_access_token
      ENV['ED_API_ACCESS_TOKEN']
    end

    def ed_app_sdk_client_id
      ENV['ED_APP_SDK_CLIENT_ID']
    end

    def ed_app_sdk_client_secret
      ENV['ED_APP_SDK_CLIENT_SECRET']
    end

    def mailgun_configured?
      ENV.values_at('MAILGUN_API_KEY', 'MAILGUN_DOMAIN').all?(&:present?)
    end
  end
end

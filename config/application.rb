require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Qaddy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es
    # I18n.locale = config.i18n.locale = config.i18n.default_locale
    config.i18n.locale = config.i18n.default_locale
    config.i18n.fallbacks = [:en]
    I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.yml').to_s]
    I18n.locale = :es

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # session store
    config.action_dispatch.session_store = :active_record_store

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # prevent initializing application and connecting to the database
    config.assets.initialize_on_precompile = false

    # See everything in the log (default is :info)
    # config.log_level = :debug

    # Prepend all log lines with the following tags
    # config.log_tags = [ :subdomain, :uuid ]

    # Use a different logger for distributed setups
    # config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

    # mailer options
    ActionMailer::Base.default(from: ENV['MAILER_DEFAULT_FROM'])
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = false
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address              => "smtp.sendgrid.net",
      :port                 => 587,
      :domain               => ENV['SENDGRID_DOMAIN'],
      :user_name            => ENV['SENDGRID_USERNAME'],
      :password             => ENV['SENDGRID_PASSWORD'],
      :authentication       => :plain,
      :enable_starttls_auto => true
    }

    # paperclip options
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['AWS_BUCKET'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      }
    }

    # bitly
    config.bitly = {
      username: ENV['BITLY_USERNAME'],
      api_key: ENV['BITLY_API_KEY']
    }

    # misc app options
    config.qaddy = {
      max_skip_send_email_for_orders_older_than_days: 60,
      webstore_email_from_format: "%{name} <%{sub}@#{ENV['MAILER_WEBSTORE_FROM_DOMAIN']}>",
      webstore_email_bcc: ENV['MAILER_WEBSTORE_BCC'],
      csv_order_import_limit_per_file: 100
    }

  end
end

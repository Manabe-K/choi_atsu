require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Master key settings (uncomment if using encrypted credentials)
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  # config.public_file_server.enabled = false

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # File sending headers (NGINX/Apache)
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # Use Cloudinary for ActiveStorage in production
  config.active_storage.service = :local
  config.active_storage.service = :cloudinary

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # SSL settings
  config.force_ssl = true
  config.ssl_options = { redirect: false }

  # Logging to STDOUT
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Caching & Active Job
  # config.cache_store = :mem_cache_store
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "myapp_production"
  config.action_mailer.perform_caching = false

  # I18n fallbacks
  config.i18n.fallbacks = true

  # Deprecation warnings
  config.active_support.report_deprecations = false

  # Prevent schema dump after migrations
  config.active_record.dump_schema_after_migration = false

  # Allow requests only from specified domains



  # Set default URL options for mailers and helpers
  Rails.application.routes.default_url_options[:host] = "choi-atsu.onrender.com"

  # Allow cookies across domains if needed
  config.action_dispatch.cookies_same_site_protection = :none
end

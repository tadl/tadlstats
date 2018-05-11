Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true

  config.force_ssl = true

  config.log_level = :debug
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.log_tags  = [ :request_id ]
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.cache_store = :dalli_store,
                    (ENV["MEMCACHED_URL"] || ""),
                    {:failover => true,
                    :socket_timeout => 1.5,
                    :socket_failure_delay => 0.2
                    }

end

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
  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.log_formatter = ::Logger::Formatter.new

  config.cache_store = :dalli_store,
                    (ENV["MEMCACHED_URL"] || ""),
                    {:failover => true,
                    :socket_timeout => 1.5,
                    :socket_failure_delay => 0.2
                    }

  config.active_record.dump_schema_after_migration = false
end

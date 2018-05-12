require_relative 'boot'

#require 'rails/all'
require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

#Dotenv::Railtie.load

module Tadlstats
  class Application < Rails::Application
    config.load_defaults 5.2

    Settings.add_source!("#{Rails.root}/config/settings/" + ENV["SYSTEM"] + ".yml")
  end
end

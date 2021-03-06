require_relative 'boot'

require 'rails/all'
#require 'carrierwave/orm/activerecord'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TryRails5
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    I18n.default_locale = :ru

    config.autoload_paths += %W(#{config.root}/app/uploaders #{config.root}/lib)
    config.autoload_paths << Rails.root.join('lib')
  end
end

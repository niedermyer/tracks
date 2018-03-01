require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tracks
  class Application < Rails::Application

    config.x.application_name.title = 'Tracks'
    config.x.application_name.parameter = config.x.application_name.title.parameterize

    config.time_zone = 'Eastern Time (US & Canada)'

    # Load all of our configuration files into Rails.configuration.x.* objects.
    # These will be available throughout other initializers, so that we don't
    # have to manually read config files in several places.
    %i{ google_maps smtp }.each do |name|
      if File.readable?(Rails.root.join("config/#{name}.yml"))
        config.x.send("#{name}=", OpenStruct.new(Rails.application.config_for(name)))
      end
    end

    # Set path for mailer previews
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

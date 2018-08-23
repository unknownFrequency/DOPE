require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Todo
  class Application < Rails::Application
    config.load_defaults 5.2

    if Rails.env.development?
      yml_file = 'local_env_for_oauth.yml'
    end
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', yml_file)
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
  end
end

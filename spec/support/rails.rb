ENV["RAILS_ENV"] ||= 'test'

begin
  load "#{ROOT}/bin/spring"
rescue LoadError
end

puts "Loading Rails..."
require "#{ROOT}/config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Allow rspec to use named routes
  config.include Rails.application.routes.url_helpers
end

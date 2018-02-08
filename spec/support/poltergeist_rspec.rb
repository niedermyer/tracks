require 'support/poltergeist'

RSpec.configure do |config|
  # Helps rspec and poltergeist play nice with database_cleaner
  # http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
  config.use_transactional_fixtures = false
end
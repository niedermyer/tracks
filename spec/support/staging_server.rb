Capybara.default_driver = :poltergeist
Capybara.app_host = "https://staging.activity-log.niedermyer.tech"
puts "Running tests against #{Capybara.app_host}"

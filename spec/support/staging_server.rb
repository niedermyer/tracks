Capybara.default_driver = :poltergeist
Capybara.app_host = "https://staging.tracks.niedermyer.tech"
puts "Running tests against #{Capybara.app_host}"

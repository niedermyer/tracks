require 'csv'

module DevelopmentSeedsHelpers

  def email_hostname
    "activity-log.test"
  end

  def users_row slug
    users_csv.find { |row| row['slug'] == slug }
  end

  def seed_data_file name
    Rails.root.join('db', 'example_data', name)
  end

  private

  def users_csv
    @users_csv ||= CSV.parse(users_csv_text, headers: true, header_converters: [:downcase])
  end

  def users_csv_text
    File.read(seed_data_file('users.csv'))
  end

end
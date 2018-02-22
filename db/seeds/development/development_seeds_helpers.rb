require 'csv'

module DevelopmentSeedsHelpers

  USER_SLUGS =   %w(
    admin
    registered
    pending
  )

  def email_hostname
    "activity-log.test"
  end

  def seed_data_file name
    Rails.root.join('db', 'example_data', name)
  end

  USER_SLUGS.each do |slug|
    %w(
      first_name
      last_name
      password
    ).each do |attr|
      define_method "#{slug}_user_#{attr}" do
        users_row(slug)[attr]
      end
    end

    define_method "#{slug}_user_email" do
      "#{slug}@#{email_hostname}"
    end

    define_method "seeded_#{slug}_user" do
      User.find_by(email: send("#{slug}_user_email"))
    end
  end

  def seeded_user_with_tracks
    seeded_registered_user
  end

  private

  def users_row slug
    users_csv.find { |row| row['slug'] == slug }
  end

  def users_csv
    @users_csv ||= CSV.parse(users_csv_text, headers: true, header_converters: [:downcase])
  end

  def users_csv_text
    File.read(seed_data_file('users.csv'))
  end
end
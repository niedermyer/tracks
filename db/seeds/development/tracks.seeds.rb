after 'development:users' do

  user_row = users_row 'user'
  user = User.find_by(email: "#{user_row['slug']}@#{email_hostname}")

  gpx_filename = seed_data_file('tracks_seed.gpx')
  Importers::TrackImporter.new(gpx_filename, user).import!

end
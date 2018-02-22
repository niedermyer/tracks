after 'development:users' do

  gpx_filename = seed_data_file('tracks_seed.gpx')
  Importers::TrackImporter.new(gpx_filename, seeded_registered_user).import!

end
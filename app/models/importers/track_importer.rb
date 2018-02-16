class Importers::TrackImporter
  class DuplicateTrackImport < RuntimeError; end

  attr_reader :filename, :user

  def initialize(filename, user)
    @filename = filename
    @user = user
  end

  def import!
    errors = []

    Track.transaction do
      gpx = GPX::GPXFile.new(:gpx_file => filename)

      gpx.tracks.each do |track|
        md5 = Digest::MD5.hexdigest track.to_s

        if user.tracks.find_by(import_fingerprint: md5)
          DuplicateTrackImport.new "This track has already been imported"
        else
          t = user.tracks.create(
            import_fingerprint: md5,
            name: track.name,
            description: track.description
          )
          track.segments.each do |segment|
            s = t.segments.create()

            segment.points.each do |point|
              s.points.create(
                latitude: point.lat,
                longitude: point.lon,
                elevation_in_meters: point.elevation,
                recorded_at: point.time
              )
            end
          end
        end
      end

    end
  end
end
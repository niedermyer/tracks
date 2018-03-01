class Importers::TrackImporter
  attr_reader :filename, :user

  def initialize(filename, user)
    @filename = filename
    @user = user
  end

  def import!
    results = []

    Track.transaction do
      gpx = GPX::GPXFile.new(:gpx_file => filename)

      gpx.tracks.each do |track|
        md5 = Digest::MD5.hexdigest track.to_s

        if t = user.tracks.find_by(import_fingerprint: md5)
          results << IgnoredDuplicateTrackImportResult.new(t)
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
                elevation: point.elevation,
                recorded_at: point.time
              )
            end
          end

          results << SuccessfulTrackImportResult.new(t)
        end
      end
    end

    results
  end
end
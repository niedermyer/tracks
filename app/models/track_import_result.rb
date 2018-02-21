class TrackImportResult
  attr_accessor :track

  def initialize(track)
    @track = track
  end
end

class SuccessfulTrackImportResult < TrackImportResult

  def status_code
    :imported_success
  end

  def message
    'Imported - a new track was successfully created.'
  end

end

class IgnoredDuplicateTrackImportResult < TrackImportResult

  def status_code
    :ignored_duplicate
  end

  def message
    'Ignored - this track was previously imported. To re-import, first delete the existing track.'
  end

end
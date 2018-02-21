# Need to autoload the TrackImportReport subclasses that reside
# in their parent class file

autoload :SuccessfulTrackImportResult, 'track_import_result'
autoload :IgnoredDuplicateTrackImportResult, 'track_import_result'
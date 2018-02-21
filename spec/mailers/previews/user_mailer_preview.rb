class UserMailerPreview < ActionMailer::Preview
  def email_import_confirmation
    user = User.find_by(email: 'user@activity-log.test')
    successful_result = SuccessfulTrackImportResult.new(user.tracks.first)
    ignored_result = IgnoredDuplicateTrackImportResult.new(user.tracks.first)
    results = [successful_result, ignored_result]
    UserMailer.email_import_confirmation(user, 'track_file.gpx', results)
  end
end
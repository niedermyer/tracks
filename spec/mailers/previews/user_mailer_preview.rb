require Rails.root.join('db/seeds/development/development_seeds_helpers')

class UserMailerPreview < ActionMailer::Preview
  include DevelopmentSeedsHelpers

  def email_import_confirmation
    successful_result = SuccessfulTrackImportResult.new(user.tracks.first)
    ignored_result = IgnoredDuplicateTrackImportResult.new(user.tracks.first)
    results = [successful_result, ignored_result]

    UserMailer.email_import_confirmation(user, 'track_file.gpx', results)
  end

  def invitation_accepted
    UserMailer.invitation_accepted(user)
  end

  private

  def user
    @user ||= seeded_user_with_tracks
  end
end
require Rails.root.join('db/seeds/development/development_seeds_helpers')

class CustomDeviseMailerPreview < ActionMailer::Preview
  include DevelopmentSeedsHelpers

  def invitation_instructions
    CustomDeviseMailer.invitation_instructions(pending_user, 'faketoken', {})
  end

  def reset_password_instructions
    CustomDeviseMailer.reset_password_instructions(user, "faketoken", {})
  end

  def email_changed
    CustomDeviseMailer.email_changed(user, {})
  end

  def password_change
    CustomDeviseMailer.password_change(user, {})
  end

  private

  def user
    @user ||= seeded_user_with_tracks
  end

  def pending_user
    @pending_user ||= seeded_pending_user
  end
end
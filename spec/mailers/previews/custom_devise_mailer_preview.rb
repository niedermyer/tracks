class CustomDeviseMailerPreview < ActionMailer::Preview

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
    @user ||= User.find_by(email: 'user@activity-log.test')
  end

  def pending_user
    @user ||= User.find_by(email: 'pending@tracks.test')
  end
end
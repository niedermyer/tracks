class UserMailer < ApplicationMailer

  def email_import_confirmation(user, gpx_filename, results)
    @user = user
    @gpx_filename = gpx_filename
    @results = results

    @host = define_host
    add_inline_attachments

    mail to: user.email,
         subject: "Emailed GPX file was processed"
  end

  def invitation_accepted(user)
    @user = user
    @inviter = user.invited_by

    @host = define_host
    add_inline_attachments

    mail to: @inviter.email,
         subject: "#{user.full_name} has Accepted Your Invitation to Tracks"
  end

end
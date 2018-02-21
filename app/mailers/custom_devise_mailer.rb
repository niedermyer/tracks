class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def invitation_instructions(record, token, opts={})
    @host = define_host
    add_inline_attachments
    super
  end

  def reset_password_instructions(record, token, opts={})
    @host = define_host
    add_inline_attachments
    super
  end

  def email_changed(record, opts={})
    @host = define_host
    add_inline_attachments
    super
  end

  def password_change(record, opts={})
    @host = define_host
    add_inline_attachments
    super
  end
end
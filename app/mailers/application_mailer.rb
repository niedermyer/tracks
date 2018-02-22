class ApplicationMailer < ActionMailer::Base
  default from: "#{Rails.configuration.x.application_name.title} <no-reply@#{Rails.configuration.x.smtp.url_options['host']}>"
  layout 'mailer'

  private

  def define_host
    OpenStruct.new(
          name: Rails.configuration.x.application_name.title,
          website_link_label: Rails.configuration.x.smtp.url_options['host'],
          website_url: root_url
    )
  end

  def add_inline_attachments
    attachments.inline['logo.png'] = File.read(Rails.root.join("app/assets/images/mailers/logo.png"))
  end
end

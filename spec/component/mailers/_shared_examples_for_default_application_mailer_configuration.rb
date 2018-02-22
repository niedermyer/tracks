shared_examples_for "a mailer that uses default ApplicationMailer configuration" do
  it 'sends the email from the correct address' do
    expect(email.from).to eq ["no-reply@#{Rails.configuration.x.smtp.url_options['host']}"]
  end

  it 'sends the email with the correct from name' do
    expect(email.header[:from].value).to match /^#{Rails.configuration.x.application_name.title}/
  end

  describe 'the message body' do
    let(:parsed_body){ Capybara::Node::Simple.new(body) }

    it 'displays in the mailer layout with logo' do
      expect(parsed_body).to have_css 'img#logo-header'
      expect(body).to include "&copy; #{Time.zone.now.year} #{Rails.configuration.x.application_name.title}"
    end
  end
end
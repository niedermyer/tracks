require 'component/component_spec_helper'
require_relative '_shared_examples_for_default_application_mailer_configuration'

shared_examples_for "a custom devise mailer" do
  it_behaves_like "a mailer that uses default ApplicationMailer configuration"

  describe 'the message body' do
    it 'displays the customized greeting' do
      expect(body).to match /<h2 class="greeting">Hi #{user.first_name},<\/h2>/
    end
  end
end

describe CustomDeviseMailer do
  let(:user) { create :user }
  let(:token) { 'fake_token' }

  describe '#invitation_instructions' do
    let(:user) { create :user, :pending_invitation }
    let(:email) { CustomDeviseMailer.invitation_instructions(user, token, {}) }
    let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

    it_behaves_like "a custom devise mailer"

    it 'sends the email to the user' do
      expect(email.to).to eq [user.email]
    end
  end

  describe '#reset_password_instructions' do
    let(:email) { CustomDeviseMailer.reset_password_instructions(user, token, {}) }
    let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

    it_behaves_like "a custom devise mailer"

    it 'sends the email to the user' do
      expect(email.to).to eq [user.email]
    end
  end

  describe '#email_changed' do
    let(:email) { CustomDeviseMailer.email_changed(user, {}) }
    let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

    it_behaves_like "a custom devise mailer"

    it 'sends the email to the user' do
      expect(email.to).to eq [user.email]
    end
  end

  describe '#password_change' do
    let(:email) { CustomDeviseMailer.password_change(user, {}) }
    let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

    it_behaves_like "a custom devise mailer"

    it 'sends the email to the user' do
      expect(email.to).to eq [user.email]
    end
  end
end
require 'component/component_spec_helper'
require_relative '_shared_examples_for_default_application_mailer_configuration'

describe UserMailer do
  let(:inviter) { build :user, :admin }
  let(:user) { create :user, invited_by: inviter }

  describe '#email_import_confirmation' do
    let(:gpx_filename) { 'track.gpx' }
    let(:results) {[ success_result, ignored_result ]}
    let(:success_result) { instance_double('SuccessfulTrackImportResult',
                                           status_code: :imported_success,
                                           track: imported_track,
                                           message: 'good import') }
    let(:ignored_result) { instance_double('IgnoredDuplicateTrackImportResult',
                                           status_code: :ignored_duplicate,
                                           track: ignored_track,
                                           message: 'not bad, but ignored') }
    let(:imported_track) { create :track, user: user, name: 'Imported Successfully Track Name' }
    let(:ignored_track) { create :track, user: user, name: 'Ignored Already Imported Track Name' }

    let(:email) { UserMailer.email_import_confirmation(user, gpx_filename, results) }
    let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

    it_behaves_like "a mailer that uses default ApplicationMailer configuration"

    it 'sends the email to the user' do
      expect(email.to).to eq [user.email]
    end

    it 'sends the email with the correct subject' do
      expect(email.subject).to eq "Emailed GPX file was processed"
    end

    describe 'the message body' do
      it 'mentions the user by name' do
        expect(body).to match user.first_name
      end
      it 'includes the gpx_filename' do
        expect(body).to include 'track.gpx'
      end
      it 'includes individual track import result details' do
        results.each do |result|
          expect(body).to include result.track.name
          expect(body).to include result.message
        end
      end
    end
  end

  describe '#invitation_accepted' do
    let(:email) { UserMailer.invitation_accepted(user) }
    let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

    it_behaves_like "a mailer that uses default ApplicationMailer configuration"

    it 'sends the email to the admin that invited the user' do
      expect(email.to).to eq [inviter.email]
    end

    it 'sends the email with the correct subject' do
      expect(email.subject).to eq "#{user.full_name} has Accepted Your Invitation to Tracks"
    end

    describe 'the message body' do
      it 'mentions the invter by name' do
        expect(body).to match /Hi #{inviter.first_name},/
      end
      it 'includes details about the invitee' do
        expect(body).to include user.first_name
        expect(body).to include user.last_name
        expect(body).to include user.email
        expect(body).to include I18n.l(user.invitation_sent_at, format: :long)
        expect(body).to include I18n.l(user.invitation_accepted_at, format: :long)
      end
    end
  end
end
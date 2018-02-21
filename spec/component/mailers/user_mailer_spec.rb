require 'component/component_spec_helper'

describe UserMailer do
  let(:user) { create :user }
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

  describe '#email_import_confirmation' do
    let(:email) { UserMailer.email_import_confirmation(user, gpx_filename, results) }

    it 'sends the email to the user' do
      expect(email.to).to eq [user.email]
    end
    it 'sends the email from the correct address' do
      expect(email.from).to eq ["no-reply@#{Rails.configuration.x.smtp.url_options['host']}"]
    end
    it 'sends the email with the correct from name' do
      expect(email.header[:from].value).to match /^Activity Log/
    end
    it 'sends the email with the correct subject' do
      expect(email.subject).to eq "Emailed GPX file was processed"
    end
    describe 'the message body' do
      let(:body){ email.parts.detect{|part| part.content_type =~ /text\/html/ }.body.raw_source }

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
end
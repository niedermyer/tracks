require 'component/component_spec_helper'

describe EmailProcessor do
  subject(:processor) { EmailProcessor.new(email) }
  let!(:user_1) { create :user, public_id: user_1_public_id }
  let(:user_1_public_id) { 'first_token' }
  let(:user_1_track_importer) { instance_double 'Importers::TrackImporter' }
  let(:user_1_results) { double 'track import results for user 1'}
  let(:user_1_mailer) { double 'mailer for user_1' }
  let(:email) { build :incoming_email }
  let(:gpx_file_path) { email.attachments.first.tempfile.path }
  let(:gpx_filename) { email.attachments.first.original_filename }


  describe '::PROCESSING_HOSTNAME' do
    subject { EmailProcessor::PROCESSING_HOSTNAME }
    it { is_expected.to eq 'parse-activity.niedermyer.tech' }
  end

  describe '#initialize' do
    it 'accepts a email object, returns an EmailProcessor' do
      expect(EmailProcessor.new(email)).to be_a EmailProcessor
    end
  end

  describe '#process' do
    before do
      allow(Digest::MD5).to receive(:hexdigest).with(email.inspect).and_return '123abc'
    end

    context 'when NONE of the relevant to email addresses belong to a user in the database' do
      let(:user_1_public_id) { 'does_not_match_given_token' }

      before do
        allow(Importers::TrackImporter).to receive(:new).with(gpx_filename, user_1).and_return user_1_track_importer
      end

      it "logs concise info for each to address, plus a full email inspection" do
        email.to.each do |to_address|
          expect(Rails.logger).to receive(:warn).with "EmailProcessor::UserNotFound [123abc] No user found with given public_id. given_public_id: #{to_address[:token]}"
        end
        expect(Rails.logger).to receive(:warn).with /^EmailProcessor::UserNotFound \[123abc\] No user found with given public_id. email_attributes: \n\[123abc\] TO: .*$/
        processor.process
      end

      it "does NOT import the tracks from the gpx file" do
        expect(user_1_track_importer).not_to receive(:import!)
        processor.process
      end
    end

    context 'when SOME of the relevant to email addresses do NOT belong to a user in the database' do
      before do
        allow(Importers::TrackImporter).to receive(:new).with(gpx_file_path, user_1).and_return user_1_track_importer
        allow(UserMailer).to receive(:email_import_confirmation).with(user_1, gpx_filename, user_1_results).and_return user_1_mailer
      end

      it "imports the tracks from the gpx file for the good email, and logs concise info for the bad to address, plus a full email inspection" do
        expect(Rails.logger).to receive(:warn).with "EmailProcessor::UserNotFound [123abc] No user found with given public_id. given_public_id: second_token"
        expect(Rails.logger).to receive(:warn).with /^EmailProcessor::UserNotFound \[123abc\] No user found with given public_id. email_attributes: \n\[123abc\] TO: .*$/
        expect(user_1_track_importer).to receive(:import!).with(no_args).and_return user_1_results
        expect(user_1_mailer).to receive(:deliver_now)
        processor.process
      end
    end

    context 'when ALL of the relevant to email addresses belongs to a user in the database' do
      let!(:user_2) { create :user, public_id: 'second_token' }
      let(:user_2_track_importer) { instance_double 'Importers::TrackImporter' }
      let(:user_2_results) { double 'track import results for user 2'}
      let(:user_2_mailer) { double 'mailer for user_2' }

      context 'when the email does NOT contain an attachment' do
        let(:email) { build :incoming_email, :with_no_attachments }

        it "logs informative message, plus a full email inspection" do
          email.to.each do |to_address|
            expect(Rails.logger).to receive(:warn).with "EmailProcessor::AttachmentNotFound [123abc] Could not find any email attachments. given_public_id: #{to_address[:token]}"
          end
          expect(Rails.logger).to receive(:warn).with /^EmailProcessor::AttachmentNotFound \[123abc\] Could not find any email attachments. email_attributes: \n\[123abc\] TO: .*$/
          processor.process
        end

        it "does NOT import any tracks" do
          expect(user_1_track_importer).not_to receive(:import!)
          expect(user_2_track_importer).not_to receive(:import!)
          processor.process
        end
      end
      context 'when the email contains an attachment that is NOT a GPX file' do
        let(:email) { build :incoming_email, :with_other_attachments }

        it "logs informative message, plus a full email inspection" do
          email.to.each do |to_address|
            expect(Rails.logger).to receive(:warn).with "EmailProcessor::UnprocessableAttachment [123abc] None of the attached files were of correct type. given_public_id: #{to_address[:token]}"
          end
          expect(Rails.logger).to receive(:warn).with /^EmailProcessor::UnprocessableAttachment \[123abc\] None of the attached files were of correct type. email_attributes: \n\[123abc\] TO: .*$/
          processor.process
        end

        it "does NOT import any tracks" do
          expect(user_1_track_importer).not_to receive(:import!)
          expect(user_2_track_importer).not_to receive(:import!)
          processor.process
        end
      end
      context 'when the email contains a GPX file attachment' do
        before do
          allow(Importers::TrackImporter).to receive(:new).with(gpx_file_path, user_1).and_return user_1_track_importer
          allow(UserMailer).to receive(:email_import_confirmation).with(user_1, gpx_filename, user_1_results).and_return user_1_mailer
          allow(Importers::TrackImporter).to receive(:new).with(gpx_file_path, user_2).and_return user_2_track_importer
          allow(UserMailer).to receive(:email_import_confirmation).with(user_2, gpx_filename, user_2_results).and_return user_2_mailer
        end

        it 'imports the track data from the GPX file' do
          expect(user_1_track_importer).to receive(:import!).with(no_args).and_return user_1_results
          expect(user_1_mailer).to receive(:deliver_now)
          expect(user_2_track_importer).to receive(:import!).with(no_args).and_return user_2_results
          expect(user_2_mailer).to receive(:deliver_now)
          processor.process
        end
      end
    end
  end
end
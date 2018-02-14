require 'component/component_spec_helper'

describe EmailProcessor do
  subject(:processor) { EmailProcessor.new(email) }
  let!(:user) { create :user, public_id: public_id }
  let(:public_id) { 'first_token' }
  let(:email) { build :incoming_email }

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
      let(:public_id) { 'does_not_match_given_token' }

      it "logs concise info for each to address, plus a full email inspection" do
        email.to.each do |to_address|
          expect(Rails.logger).to receive(:warn).with "EmailProcessor::UserNotFound [123abc] No user found with given public_id. given_public_id: #{to_address[:token]}"
        end
        expect(Rails.logger).to receive(:warn).with /^EmailProcessor::UserNotFound \[123abc\] No user found with given public_id. email_attributes: \n\[123abc\] TO: .*$/
        processor.process
      end
    end

    context 'when SOME of the relevant to email addresses do NOT belong to a user in the database' do
      it "only logs concise info for the bad to address, plus a full email inspection" do
        expect(Rails.logger).to receive(:warn).with "EmailProcessor::UserNotFound [123abc] No user found with given public_id. given_public_id: second_token"
        expect(Rails.logger).to receive(:warn).with /^EmailProcessor::UserNotFound \[123abc\] No user found with given public_id. email_attributes: \n\[123abc\] TO: .*$/
        processor.process
      end
    end

    context 'when ALL of the relevant to email addresses belongs to a user in the database' do
      let!(:user_2) { create :user, public_id: 'second_token' }

      context 'when the email does NOT contain an attachment' do
        let(:email) { build :incoming_email, :with_no_attachments }

        it "logs informative message, plus a full email inspection" do
          email.to.each do |to_address|
            expect(Rails.logger).to receive(:warn).with "EmailProcessor::AttachmentNotFound [123abc] Could not find any email attachments. given_public_id: #{to_address[:token]}"
          end
          expect(Rails.logger).to receive(:warn).with /^EmailProcessor::AttachmentNotFound \[123abc\] Could not find any email attachments. email_attributes: \n\[123abc\] TO: .*$/
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
      end
      context 'when the email contains a GPX file attachment'
    end
  end
end
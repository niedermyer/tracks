require 'component/component_spec_helper'

describe EmailProcessor do
  subject(:processor) { EmailProcessor.new(email) }
  let!(:user) { create :user, public_id: public_id }
  let(:public_id) { 'user_public_id' }
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
      let(:public_id) { 'does_not_belong_to_user' }

      it "logs concise info for each to address, plus a full email inspection" do
        email.to.each do |to_address|
          expect(Rails.logger).to receive(:info).with(
            /^EmailProcessorFailedAttempt::UserNotFound \[123abc\] to: #{to_address[:full]}$/
          )
        end
        expect(Rails.logger).to receive(:info).with(
          /^EmailProcessorFailedAttempt::UserNotFound \[123abc\] email: #<OpenStruct.*$/
        )
        processor.process
      end
    end
    context 'when some of the relevant to email addresses do NOT belong to a user in the database' do
      it "only logs concise info for the bad to address, plus a full email inspection" do
        expect(Rails.logger).to receive(:info).with(
          /^EmailProcessorFailedAttempt::UserNotFound \[123abc\] to: bogus@#{EmailProcessor::PROCESSING_HOSTNAME}$/
        )
        expect(Rails.logger).to receive(:info).with(
          /^EmailProcessorFailedAttempt::UserNotFound \[123abc\] email: #<OpenStruct.*$/
        )
        processor.process
      end
    end

    context 'when ALL of the relevant to email addresses belongs to a user in the database' do
      context 'when the email does NOT contain an attachment'
      context 'when the email contains an attachment that is NOT a GPX file'
      context 'when the email contains a GPX file attachment'
    end
  end
end
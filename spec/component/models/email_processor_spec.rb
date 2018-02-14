require 'component/component_spec_helper'

describe EmailProcessor do
  subject(:processor) { EmailProcessor.new(email) }
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
end
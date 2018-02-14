require 'component/component_spec_helper'

describe EmailProcessor do
  subject(:processor) { EmailProcessor.new(email) }
  let(:email) { build :incoming_email }

  describe '#initialize' do
    it 'accepts a email object, returns an EmailProcessor' do
      expect(EmailProcessor.new(email)).to be_a EmailProcessor
    end
  end
end
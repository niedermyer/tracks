require 'component/component_spec_helper'

describe ApplicationHelper, type: :helper do
  describe '#page_classes' do
    subject{ helper.page_classes }

    before do
      allow(controller).to receive(:controller_name).and_return 'foo'
      allow(controller).to receive(:action_name).and_return 'bar'
    end

    it { is_expected.to eq 'foo bar' }
  end
end
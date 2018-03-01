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

  describe '#google_maps_api?' do
    subject{ helper.google_maps_api? }

    context 'when it is a controller & action that requires the google maps api' do
      before do
        allow(controller).to receive(:controller_name).and_return 'tracks'
        allow(controller).to receive(:action_name).and_return 'show'
      end

      it { is_expected.to be true }
    end

    context 'when it is NOT a controller & action that requires the google maps api' do
      before do
        allow(controller).to receive(:controller_name).and_return 'no'
        allow(controller).to receive(:action_name).and_return 'google'
      end

      it { is_expected.to be false }
    end
  end
end
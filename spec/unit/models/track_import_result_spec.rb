require 'unit/unit_spec_helper'
require ROOT.join('app/models/track_import_result')

shared_examples_for "a track import result" do
  describe '#new' do
    it 'accepts a Track' do
      expect(described_class.new(track).track).to eq track
    end
  end

  it { is_expected.to respond_to :status_code }
  it { is_expected.to respond_to :message }
end

describe SuccessfulTrackImportResult do
  subject(:result) { SuccessfulTrackImportResult.new(track) }
  let(:track) { instance_double 'Track' }
  it_behaves_like 'a track import result'

  describe '#status_code' do
    subject { result.status_code }
    it { is_expected.to eq :imported_success }
  end

  describe '#message' do
    subject { result.message }
    it { is_expected.to eq 'Imported - a new track was successfully created.' }
  end
end

describe IgnoredDuplicateTrackImportResult do
  subject(:result) { IgnoredDuplicateTrackImportResult.new(track) }
  let(:track) { instance_double 'Track' }
  it_behaves_like 'a track import result'

  describe '#status_code' do
    subject { result.status_code }
    it { is_expected.to eq :ignored_duplicate }
  end

  describe '#message' do
    subject { result.message }
    it { is_expected.to eq 'Ignored - this track was previously imported. To re-import, first delete the existing track.' }
  end
end
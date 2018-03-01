require 'component/component_spec_helper'

describe TrackPoint, type: :model do

  describe 'the track_points table' do
    subject { TrackPoint.new }
    it { is_expected.to have_db_column(:latitude).of_type(:decimal).with_options(precision: 10, scale: 6) }
    it { is_expected.to have_db_column(:longitude).of_type(:decimal).with_options(precision: 10, scale: 6) }
    it { is_expected.to have_db_column(:elevation).of_type(:decimal).with_options(precision: 10, scale: 6) }
    it { is_expected.to have_db_column(:recorded_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:track_segment_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:track_segment_id) }
    it { is_expected.to have_db_index(:recorded_at) }

    it { is_expected.to have_db_foreign_key(:track_segment_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:track_segment) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:elevation) }
    it { is_expected.to validate_presence_of(:recorded_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:track_segment).inverse_of(:points) }
  end

  describe 'scopes' do
    let!(:track) { create :track, segments: [segment] }
    let(:segment) { build :track_segment, track: nil, points: [second, first, third] }
    let(:second) { build :track_point, track_segment: nil, recorded_at: now - 1.hour }
    let(:first)  { build :track_point, track_segment: nil, recorded_at: now - 2.hours }
    let(:third)  { build :track_point, track_segment: nil, recorded_at: now }
    let(:now) { Time.zone.now }

    describe 'default_scope' do
      it 'sorts by recorded_at ascending' do
        expect(TrackPoint.all).to eq [first, second, third]
      end
    end
  end

  describe '#latitude_longitude' do
    subject { point.latitude_longitude }
    let(:point) { build :track_point }

    it { is_expected.to eq [point.latitude, point.longitude] }
  end

  describe '#rounded_elevation' do
    subject { point.rounded_elevation }
    let(:point) { build :track_point, elevation: elevation }

    context 'when elevation is 0.555' do
      let(:elevation) { BigDecimal('0.555') }
      it { is_expected.to eq BigDecimal('0.56') }
    end

    context 'when elevation is 1.005' do
      let(:elevation) { BigDecimal('1.005') }
      it { is_expected.to eq BigDecimal('1.01') }
    end

    context 'when elevation is 1.999' do
      let(:elevation) { BigDecimal('1.999') }
      it { is_expected.to eq BigDecimal('2') }
    end
  end
end

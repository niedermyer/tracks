require 'component/component_spec_helper'

describe Track, type: :model do

  describe 'the tracks table' do
    subject { Track.new }
    it { is_expected.to have_db_column(:import_fingerprint).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:user_id) }

    it { is_expected.to have_db_foreign_key(:user_id)}
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:segments).class_name('TrackSegment').dependent(:destroy) }
    it { is_expected.to have_many(:points).through(:segments).class_name('TrackPoint') }
  end

  describe '#polyline_coordinates' do
    let(:track) { create :track, segments: [segment] }
    let(:segment) { build :track_segment, track: nil, points: [point_1, point_2] }
    let(:point_1) { build :track_point, track_segment: nil }
    let(:point_2) { build :track_point, track_segment: nil }

    it "returns an sequential array of the track's points' latitudes_longitude" do
      expect(track.polyline_coordinates).to eq [ point_1.latitude_longitude, point_2.latitude_longitude]
    end
  end

  describe '#polyline' do
    let(:track) { create :track }

    before do
      allow(Polylines::Encoder).to receive(:encode_points).with(track.polyline_coordinates).and_return 'encoded polyline'
    end

    it "the encoded polyline" do
      expect(track.polyline).to eq 'encoded polyline'
    end
  end
end

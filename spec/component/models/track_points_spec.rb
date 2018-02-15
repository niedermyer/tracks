require 'component/component_spec_helper'

describe TrackPoint, type: :model do

  describe 'the track_points table' do
    subject { TrackPoint.new }
    it { is_expected.to have_db_column(:latitude).of_type(:decimal).with_options(precision: 10, scale: 6) }
    it { is_expected.to have_db_column(:longitude).of_type(:decimal).with_options(precision: 10, scale: 6) }
    it { is_expected.to have_db_column(:elevation_in_meters).of_type(:decimal).with_options(precision: 10, scale: 6) }
    it { is_expected.to have_db_column(:recorded_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:track_segment_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:track_segment_id) }

    it { is_expected.to have_db_foreign_key(:track_segment_id)}
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:track_segment) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:elevation_in_meters) }
    it { is_expected.to validate_presence_of(:recorded_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:track_segment).inverse_of(:points) }
  end

end

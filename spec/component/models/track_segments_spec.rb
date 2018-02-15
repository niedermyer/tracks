require 'component/component_spec_helper'

describe TrackSegment, type: :model do

  describe 'the track_segments table' do
    subject { TrackSegment.new }
    it { is_expected.to have_db_column(:track_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    xit { is_expected.to have_db_index(:track_id) }

    xit { is_expected.to have_db_foreign_key(:track_id)}
  end

  describe 'validations' do
    xit { is_expected.to validate_presence_of(:track) }
  end

  describe 'associations' do
    it { is_expected.to belong_to :track }
    it { is_expected.to have_many(:points).class_name('TrackPoint').dependent(:destroy) }
  end

end

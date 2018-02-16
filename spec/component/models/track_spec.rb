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

end

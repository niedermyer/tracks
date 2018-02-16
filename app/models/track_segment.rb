class TrackSegment < ApplicationRecord

  belongs_to :track,
             inverse_of: :segments
  has_many :points,
           class_name: 'TrackPoint',
           inverse_of: :track_segment,
           dependent: :destroy

  validates :track,
            presence: true
end
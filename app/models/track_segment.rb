class TrackSegment < ApplicationRecord

  belongs_to :track
  has_many :points,
           class_name: 'TrackPoint',
           dependent: :destroy

end
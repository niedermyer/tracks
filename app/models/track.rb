class Track < ApplicationRecord

  belongs_to :user
  has_many :segments,
           class_name: 'TrackSegment',
           inverse_of: :track,
           dependent: :destroy
  has_many :points,
           through: :segments,
           class_name: 'TrackPoint'

  validates :user,
            presence: true
end
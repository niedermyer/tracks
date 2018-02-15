class TrackPoint < ApplicationRecord

  belongs_to :track_segment

  validates :latitude,
            :longitude,
            :elevation_in_meters,
            :recorded_at,
            presence: true
end
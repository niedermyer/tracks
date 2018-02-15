class TrackPoint < ApplicationRecord

  belongs_to :track_segment,
             inverse_of: :points

  validates :track_segment,
            :latitude,
            :longitude,
            :elevation_in_meters,
            :recorded_at,
            presence: true
end
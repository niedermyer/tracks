class TrackPoint < ApplicationRecord

  belongs_to :track_segment,
             inverse_of: :points

  validates :track_segment,
            :latitude,
            :longitude,
            :elevation,
            :recorded_at,
            presence: true

  default_scope { order(recorded_at: :asc) }

  def latitude_longitude
    [latitude, longitude]
  end

  def rounded_elevation
    elevation.round(2)
  end
end
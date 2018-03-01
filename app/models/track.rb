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

  def polyline_coordinates
    points.map{|p| p.latitude_longitude }
  end

  def polyline
    Polylines::Encoder.encode_points(polyline_coordinates)
  end
end
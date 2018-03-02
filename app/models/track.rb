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

  def duration
    @duration ||= last_point.recorded_at - first_point.recorded_at
  end

  def formatted_duration
    d = duration
    days    = d/86400
    hours   = d/3600%24
    minutes = d/60%60
    seconds = d%60

    string = ''
    string += ("%d days " % days) if days > 2
    string += ("%d day " % days) if (2 > days && days > 1)
    string += ("%d:" % hours)     if hours > 1
    string += ("%02d:" % minutes) if minutes > 1
    string += "%02d" % seconds
    string
  end

  def first_point
    @first_point ||= points.first
  end

  def last_point
    @last_point ||= points.last
  end

  def highest_point
    @highest_point ||= points.max_by(&:elevation)
  end

  def lowest_point
    @lowest_point ||= points.min_by(&:elevation)
  end
end
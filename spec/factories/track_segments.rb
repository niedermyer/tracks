FactoryBot.define do
  factory :track_segment do
    track

    after :build do |track_segment|
      if track_segment.points.empty?
        track_segment.points = build_list(:track_point, 3, track_segment: track_segment)
      end
    end

  end
end

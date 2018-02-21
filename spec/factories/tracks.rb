FactoryBot.define do
  factory :track do
    user
    sequence(:name) {|sn| "Track ##{sn}" }

    after :build do |track|
      if track.segments.empty?
        track.segments = build_list(:track_segment, 1, track: track)
      end
    end

  end
end

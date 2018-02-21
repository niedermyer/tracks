FactoryBot.define do
  factory :track_point do
    track_segment
    sequence(:latitude) {|sn| BigDecimal("#{sn}.111111") }
    sequence(:longitude) {|sn| BigDecimal("#{sn}.222222") }
    sequence(:elevation_in_meters) {|sn| BigDecimal("#{sn}.333333") }
    recorded_at { Time.zone.now }
  end
end

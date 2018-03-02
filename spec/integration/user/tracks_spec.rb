require 'integration/integration_spec_helper'

feature 'Tracks management', type: :feature do
  let!(:user) { create :user }
  let!(:track_1) { create :track,
                          user: user,
                          name: 'Track One',
                          description: 'First Route to Work' }
  let!(:track_2) { create :track,
                          user: user,
                          name: 'Track Two',
                          description: 'Second Route to Work',
                          segments: [t2_segment]}
  let(:t2_segment) { build :track_segment,
                           track: nil,
                           points: [t2_point_first, t2_point_lowest, t2_point_highest, t2_point_last]}

  let(:t2_point_first)   { build :track_point,
                                 track_segment: nil,
                                 elevation: BigDecimal('200'),
                                 recorded_at: now - 3.hour }
  let(:t2_point_lowest)  { build :track_point,
                                 track_segment: nil,
                                 elevation: BigDecimal('100'),
                                 recorded_at: now - 2.hour }
  let(:t2_point_highest) { build :track_point,
                                 track_segment: nil,
                                 elevation: BigDecimal('300'),
                                 recorded_at: now - 1.hour }
  let(:t2_point_last)    { build :track_point,
                                 track_segment: nil,
                                 elevation: BigDecimal('200'),
                                 recorded_at: now - 30.minutes }
  let(:now) { Time.zone.now }

  before do
    sign_in_as user
    visit user_tracks_path
  end

  scenario 'see all my tracks' do
    within '#global-navigation' do
      click_link 'Tracks'
    end

    within dom_id_selector(track_1) do
      expect(page).to have_link 'Track One'
    end

    within dom_id_selector(track_2) do
      expect(page).to have_link 'Track Two'
    end
  end

  scenario 'see a track', js: true do
    within dom_id_selector(track_2) do
      click_link 'Track Two'
    end

    within 'h1' do
      expect(page).to have_content track_2.name
    end

    sleep(0.1) until page.evaluate_script('$.active') == 0
    sleep 1
    expect(page).to have_css '#g-map .gm-style'

    within '.track-details' do
      expect(page).to have_content '2:30:00'
      expect(page).to have_link I18n.l(t2_point_first.recorded_at, format: :medium)
      expect(page).to have_link I18n.l(t2_point_last.recorded_at, format: :medium)
      expect(page).to have_link t2_point_lowest.rounded_elevation
      expect(page).to have_link t2_point_highest.rounded_elevation
    end

    first_point = track_2.points.first
    within dom_id_selector(first_point) do
      expect(page).to have_link I18n.l(first_point.recorded_at, format: :h_mm_ss)
    end

    last_point = track_2.points.last
    within dom_id_selector(last_point) do
      expect(page).to have_link I18n.l(last_point.recorded_at, format: :h_mm_ss)
    end

    # Google Maps link works
    expect(page).not_to have_content first_point.latitude
    expect(page).not_to have_content first_point.longitude
    expect(page).not_to have_content first_point.rounded_elevation
    within dom_id_selector(first_point) do
      click_link I18n.l(first_point.recorded_at, format: :h_mm_ss)
    end

    expect(page).to have_content first_point.latitude
    expect(page).to have_content first_point.longitude
    expect(page).to have_content first_point.rounded_elevation
  end

end

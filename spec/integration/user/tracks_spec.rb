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
                          description: 'Second Route to Work' }

  let(:now) { Time.zone.now }
  let(:yesterday) { now - 1.day }


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

  scenario 'see one track', js: true do
    within dom_id_selector(track_2) do
      click_link 'Track Two'
    end

    within 'h1' do
      expect(page).to have_content track_2.name
    end

    sleep(0.1) until page.evaluate_script('$.active') == 0
    sleep 1
    expect(page).to have_css '#g-map .gm-style'

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

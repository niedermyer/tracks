require 'integration/integration_spec_helper'

feature 'Home page', type: :feature do

  scenario 'displays the correct content' do
    visit root_path
    expect(page).to have_content Rails.configuration.x.application_name.title
  end
end


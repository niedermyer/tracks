require_relative 'system_spec_helper'

describe 'On the deployed application', type: :system do

  specify "the public home page renders" do
    visit '/'
    expect(page).to have_content Rails.configuration.x.application_name.title
  end

end

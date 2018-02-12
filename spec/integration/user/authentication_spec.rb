require 'integration/integration_spec_helper'

feature 'Authentication for User', type: :feature do
  let!(:devise_model)        { create :user }
  let(:auth_required_path)   { user_dashboard_path }
  let(:after_login_path)     { user_dashboard_path }
  let(:after_logout_path)    { root_path }
  let(:login_screen_path)    { new_user_session_path }
  let(:forgot_password_path) { new_user_password_path }

  before do
    visit login_screen_path
  end

  scenario "attempting to access a private page when not signed in" do
    visit auth_required_path

    expect(page.current_path).to eq login_screen_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end

  scenario 'logging in & out' do
    fill_in 'Email', with: devise_model.email
    fill_in 'Password', with: devise_model.password
    click_button "Sign In"

    # logged in
    expect(current_path).to eq after_login_path
    expect(page).to have_content I18n.t('devise.sessions.signed_in')

    # logging out
    click_on 'Sign Out'

    # redirected to login screen
    expect(current_path).to eq after_logout_path
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end

  scenario 'forgot password' do
    click_link "Forgot your password?"
    expect(current_path).to eq forgot_password_path

    fill_in 'Email', with: devise_model.email
    click_button "Send me reset password instructions"

    # on login screen
    expect(current_path).to eq login_screen_path
    expect(page).to have_content I18n.t('devise.passwords.send_instructions')

    # open email and follow link
    open_email devise_model.email
    current_email.click_link 'Change my password'

    # edit password
    fill_in 'New password', with: 'superSecret123', match: :prefer_exact
    fill_in 'Confirm your new password', with: 'superSecret123', match: :prefer_exact
    click_button "Change my password"

    # logged in and redirected to after log in screen
    expect(current_path).to eq after_login_path
    expect(page).to have_content I18n.t('devise.passwords.updated')
  end

  scenario 'account locked' do
    9.times {
      fill_in 'Email', with: devise_model.email
      fill_in 'Password', with: 'bogus'
      click_button "Sign In"
    }

    expect(page).to have_content I18n.t('devise.failure.last_attempt')

    fill_in 'Email', with: devise_model.email
    fill_in 'Password', with: 'bogus'
    click_button "Sign In"

    expect(page).to have_content I18n.t('devise.failure.locked')
  end
end
require 'integration/integration_spec_helper'

feature 'User invitations as an administrator user', type: :feature do
  let!(:admin) { create :user, :admin }

  before do
    sign_in_as admin
    visit user_dashboard_path
  end

  scenario 'invite another user successfully' do
    click_on 'Admin'
    click_on 'Invite New User'

    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'First name', with: 'FIRST'
    fill_in 'Last name', with: 'LAST'
    click_on 'Send User Invitation'

    # redirected to the index
    expect(page).to have_content I18n.t("devise.invitations.send_instructions", email: 'new_user@example.com')

    within dom_id_selector(User.last) do
      expect(page).to have_content 'new_user@example.com | PENDING'
      expect(page).to have_content 'FIRST'
      expect(page).to have_content 'LAST'
    end

    open_email 'new_user@example.com'

    expect(current_email.from).to include /no-reply/
    expect(current_email.reply_to).to include /no-reply/
    expect(current_email.subject).to eq "Invitation to Luke Niedermyer's Activity Log"
    expect(current_email).to have_content 'Hello FIRST'
    expect(current_email).to have_content 'Luke Niedermyer has invited you to join Activity Log.'

    current_email.click_link 'Accept Invitation'

    expect(page.current_path).to eq accept_user_invitation_path
    expect(find_field('First name').value).to eq 'FIRST'
    expect(find_field('Last name').value).to eq 'LAST'

    fill_in 'First name', with: 'NEWFIRST'
    fill_in 'Last name', with: 'UPDATEDLAST'
    fill_in 'Password', with: 'k33pitsecret', match: :prefer_exact
    fill_in 'Password confirmation', with: 'k33pitsecret', match: :prefer_exact
    click_on I18n.t("devise.invitations.edit.submit_button")

    expect(page).to have_content I18n.t('devise.invitations.updated')
    expect(page.current_path).to eq root_path

    User.find_by(email: 'new_user@example.com').tap do |u|
      expect(u.first_name).to eq 'NEWFIRST'
      expect(u.last_name).to eq 'UPDATEDLAST'
    end
  end

  scenario 'invite another user with errors' do
    visit new_user_invitation_path

    fill_in 'First name', with: 'FIRST'
    fill_in 'Last name', with: 'LAST'
    click_on 'Send User Invitation'

    # redirected to the invite form
    expect(current_path).to eq user_invitation_path
    expect(page).to have_content "Email can't be blank"
  end
end

feature 'User invitations as an base user', type: :feature do
  let!(:admin) { create :user, :admin }
  let!(:user) { create :user, administrator: false }

  before do
    sign_in_as user
    visit user_dashboard_path
  end

  scenario 'Admin link is not displayed' do
    expect(page).not_to have_link 'Admin'
  end

  %w(
    admin_root_path
    admin_users_path
    new_user_invitation_path
  ).each do |admin_path|
    scenario "#{admin_path} renders a 404" do
      expect { visit send(admin_path) }.to raise_error ActionController::RoutingError
    end
  end

  scenario 'not permitted to manually send a user invitation' do
    expect {
      page.driver.submit :post, user_invitation_path, {
        user: {
          first_name: 'FIRST VIA REST',
          last_name: 'LAST VIA REST',
          email: 'super_hax@example.com'
        }
      }
    }.to raise_error ActionController::RoutingError

    expect(User.find_by(email: 'super_hax@example.com')).to eq nil
  end
end

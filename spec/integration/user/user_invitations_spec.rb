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
      expect(page).to have_content 'Pending'
      expect(page).to have_link 'new_user@example.com'
    end

    open_email 'new_user@example.com'

    expect(current_email.from).to include /no-reply/
    expect(current_email.reply_to).to include /no-reply/
    expect(current_email.subject).to eq "Invitation to Luke Niedermyer's Activity Log"
    expect(current_email).to have_content 'Hello FIRST'
    expect(current_email).to have_content 'Luke Niedermyer has invited you to join Activity Log.'

    current_email.click_link I18n.t("devise.mailer.invitation_instructions.accept")

    expect(page.current_path).to eq accept_user_invitation_path
    expect(page).to have_css "#user_email[disabled='disabled']"
    expect(find_field('Email', disabled: true).value).to eq 'new_user@example.com'
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

  context 'given a pending invitee' do
    let!(:pending_invitee) { create :user, :pending_invitation }

    before { visit admin_users_path }

    scenario "resending an invitation from the index page" do
      clear_emails # Sanity

      click_on "Resend Invitation"

      expect(page).to have_content I18n.t("user.flashes.resend_invite.notice", identifier: pending_invitee.email)
      expect(page.current_path).to eq admin_users_path

      open_email pending_invitee.email
      expect(current_email).to have_link I18n.t("devise.mailer.invitation_instructions.accept")
    end

    scenario "resending an invitation from the show page" do
      within dom_id_selector(pending_invitee) do
        click_on 'View'
      end

      clear_emails # Sanity

      click_on "Resend Invitation"

      expect(page).to have_content I18n.t("user.flashes.resend_invite.notice", identifier: pending_invitee.email)
      expect(page.current_path).to eq admin_user_path(pending_invitee)

      open_email pending_invitee.email
      expect(current_email).to have_link I18n.t("devise.mailer.invitation_instructions.accept")
    end

    scenario "deleting the pending user and invitation" do
      expect(User.count).to eq 2
      within dom_id_selector(pending_invitee) do
        click_on 'View'
      end

      # Ensure that a confirmation dialog appears when clicking the delete button
      expect(page).to have_css("a[data-method='delete'][data-confirm='#{I18n.t('user.confirmations.destroy_pending', identifier: pending_invitee.email)}']", text: 'Delete Pending User')
      click_on "Delete Pending User"

      expect(User.count).to eq 1
      expect(page.current_path).to eq admin_users_path
      expect(page).to have_content I18n.t('user.flashes.destroy.notice', identifier: "#{pending_invitee.full_name} <#{pending_invitee.email}>")
      expect(page).not_to have_css "#user_#{pending_invitee.id}"
    end
  end
end

feature 'User invitations as an base user', type: :feature do
  let!(:admin) { create :user, :admin }
  let!(:user) { create :user, administrator: false }
  let!(:pending_invitee) { create :user, :pending_invitation }

  before do
    sign_in_as user
    visit user_dashboard_path
  end

  %w(
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

  scenario 'not permitted to manually resend a user invitation' do
    clear_emails # Sanity

    expect {
      page.driver.submit :post, admin_user_duplicate_invitation_path(pending_invitee), {}
    }.to raise_error ActionController::RoutingError

    open_email pending_invitee.email
    expect(current_email).to eq nil
  end
end

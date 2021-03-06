require 'integration/integration_spec_helper'

feature 'User management as administrator user', type: :feature do
  let!(:admin) { create :user, :admin }
  let!(:user_1) { create :user,
                         :pending_invitation,
                         invited_by_id: admin.id }
  let!(:user_2) { create :user,
                         invited_by_id: admin.id,
                         invitation_created_at: yesterday,
                         invitation_sent_at: yesterday,
                         invitation_accepted_at: now }
  let(:now) { Time.zone.now }
  let(:yesterday) { now - 1.day }


  before do
    sign_in_as admin
    visit admin_users_path
  end

  scenario 'see all users' do
    within dom_id_selector(admin) do
      expect(page).to have_content 'Administrator'
      expect(page).to have_link admin.email
      expect(page).to have_content admin.full_name
      expect(page).to have_link 'View'
      expect(page).not_to have_link 'Resend Invitation'
    end

    within dom_id_selector(user_1) do
      expect(page).to have_content 'Pending'
      expect(page).to have_link user_1.email
      expect(page).to have_content user_1.full_name
      expect(page).to have_link 'View'
      expect(page).to have_link 'Resend Invitation'
    end

    within dom_id_selector(user_2) do
      expect(page).not_to have_content 'Pending'
      expect(page).not_to have_content 'Administrator'
      expect(page).to have_link user_2.email
      expect(page).to have_content user_2.full_name
      expect(page).to have_link 'View'
      expect(page).not_to have_link 'Resend Invitation'
    end
  end

  scenario 'see a complete user' do
    within dom_id_selector(user_2) do
      click_link 'View'
    end

    expect(page).to have_current_path(admin_user_path(user_2))

    within 'h1' do
      expect(page).to have_content user_2.full_name
    end

    expect(page).to have_content user_2.first_name
    expect(page).to have_content user_2.last_name
    expect(page).to have_content user_2.email
    expect(page).to have_content user_2.processing_email
    expect(page).to have_content "Administrator #{user_2.administrator?}"
    expect(page).to have_content I18n.l(user_2.created_at, format: :long)
    expect(page).to have_content I18n.l(user_2.created_at, format: :long)

    expect(page).to have_link admin.full_name, href: admin_user_path(admin)
    expect(page).to have_content I18n.l(user_2.invitation_sent_at, format: :long)
    expect(page).to have_content I18n.l(user_2.invitation_accepted_at, format: :long)

    expect(page).not_to have_link 'Resend Invitation'
    expect(page).not_to have_link 'Delete Pending User'
  end

  scenario 'see a pending user' do
    within dom_id_selector(user_1) do
      click_link 'View'
    end

    expect(page).to have_current_path(admin_user_path(user_1))

    within 'h1' do
      expect(page).to have_content user_1.full_name
    end

    expect(page).to have_link admin.full_name, href: admin_user_path(admin)
    expect(page).to have_content I18n.l(user_1.invitation_sent_at, format: :long)
    expect(page).to have_content "PENDING"

    expect(page).to have_link 'Resend Invitation'
    expect(page).to have_link 'Delete Pending User'
  end

  scenario 'delete an user' do
    expect(User.count).to eq 3

    within dom_id_selector(user_2) do
      click_on 'Edit'
    end

    # Ensure that a confirmation dialog appears when clicking the delete button
    id = "#{user_2.full_name} <#{user_2.email}>"
    expect(page).to have_css("a[data-method='delete'][data-confirm='#{I18n.t('user.confirmations.destroy', identifier: id)}']", text: "Delete User" )
    click_on "Delete User"

    expect(User.count).to eq 2
    expect(page.current_path).to eq admin_users_path
    expect(page).to have_content I18n.t('user.flashes.destroy.notice', identifier: "#{id}")
  end
end

feature 'User management as an base user', type: :feature do
  let!(:admin) { create :user, :admin }
  let!(:user_1) { create :user, administrator: false }
  let!(:user_2) { create :user, administrator: false }

  before do
    sign_in_as user_1
    visit user_dashboard_path
  end

  scenario 'Admin link is not displayed' do
    expect(page).not_to have_link 'Admin'
  end

  %w(
    admin_root_path
    admin_users_path
  ).each do |admin_path|
    scenario "#{admin_path} renders a 404" do
      expect { visit send(admin_path) }.to raise_error ActionController::RoutingError
    end
  end

  %w(
    admin_user_path
    admin_edit_user_path
  ).each do |admin_path|
    scenario "#{admin_path}(user_2) renders a 404" do
      expect { visit send(admin_path, user_2) }.to raise_error ActionController::RoutingError
    end
  end

  scenario 'not permitted to manually resend invitation to a user' do
    starting_user_count = 3
    expect(User.count).to eq starting_user_count

    expect {
      page.driver.submit :delete, admin_destroy_user_path(user_2), {}
    }.to raise_error ActionController::RoutingError

    expect(User.count).to eq starting_user_count
    expect(User.find_by(email: user_2.email)).not_to eq nil
  end

  scenario 'not permitted to manually destroy a user' do
    starting_user_count = 3
    expect(User.count).to eq starting_user_count

    expect {
      page.driver.submit :delete, admin_destroy_user_path(user_2), {}
    }.to raise_error ActionController::RoutingError

    expect(User.count).to eq starting_user_count
    expect(User.find_by(email: user_2.email)).not_to eq nil
  end
end
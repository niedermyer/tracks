# This module knows how to read the users.csv seed data to
# allow us to keep the user details in a single file
require_relative 'development_seeds_helpers'
extend DevelopmentSeedsHelpers

# Admin User who can manage other users
admin_user = User.find_or_initialize_by(email: admin_user_email)
admin_user.password = admin_user.password_confirmation = admin_user_password
admin_user.assign_attributes(first_name: admin_user_first_name,
                             last_name: admin_user_last_name,
                             administrator: true
)
admin_user.save!

# Registered user (will also be seeded with a track)
# We also want this user to fully imitate an admin_user-invited
# user that has accepted their invitation
registered_user = User.find_or_initialize_by(email: registered_user_email)
registered_user.password = registered_user.password_confirmation = registered_user_password
registered_user.assign_attributes(first_name: registered_user_first_name,
                                  last_name: registered_user_last_name,
                                  invitation_sent_at: Time.zone.now, # simulate notification being sent
                                  administrator: false
)
registered_user.save!
registered_user.invite!(admin_user, skip_invitation: true)
registered_user.accept_invitation!


# Pending user for testing invitation functionality & invitation preview
unless seeded_pending_user.present?
  User.invite!({ email: pending_user_email,
                 first_name: pending_user_first_name,
                 last_name: pending_user_last_name,
                 invitation_sent_at: Time.zone.now, # simulate notification being sent
                 administrator: false,
                 skip_invitation: true
               },
               admin_user
  )
end

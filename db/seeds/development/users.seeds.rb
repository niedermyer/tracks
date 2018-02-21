require_relative 'development_seeds_helpers'
extend DevelopmentSeedsHelpers

administrator_row = users_row 'administrator'
user_row = users_row 'user'
pending_row = users_row 'pending'

# Admin User who can manage other users
administrator_email = "#{administrator_row['slug']}@#{email_hostname}"
admin_user = User.find_or_initialize_by(email: administrator_email)
admin_user.password = admin_user.password_confirmation = administrator_row['password']
admin_user.assign_attributes(first_name: administrator_row['first_name'],
                             last_name: administrator_row['last_name'],
                             administrator: true
)
admin_user.save!

# Non-admin user
user_email = "#{user_row['slug']}@#{email_hostname}"
user = User.find_or_initialize_by(email: user_email)
user.password = user.password_confirmation = user_row['password']
user.assign_attributes(first_name: user_row['first_name'],
                       last_name: user_row['last_name'],
                       administrator: false
)
user.save!

# Pending user
pending_email = "#{pending_row['slug']}@#{email_hostname}"
unless User.find_by(email: pending_email)
  User.invite!({ email: pending_email,
                 first_name: pending_row['first_name'],
                 last_name: pending_row['last_name'],
                 skip_invitation: true
               },
               admin_user
  )
end

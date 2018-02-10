# Admin User who can manage other users
admin_user = User.find_or_initialize_by(email: 'admin@activity-log.test')
admin_user.password = admin_user.password_confirmation = 'GmKNzE8p22LQ6FFjtC9DMD5suWbEJ4KH3cZrlUwvSOjeGJkeeDdnRB2VmCkEfeE2'
admin_user.assign_attributes(first_name: 'Admin',
                             last_name: 'User',
                             administrator: true
)
admin_user.save!

# Non-admin user
user = User.find_or_initialize_by(email: 'user@activity-log.test')
user.password = user.password_confirmation = 'qD7TrCegNlGQNGMsEMXv5TmzHpVV6CXAhP0O0sLv0GsQsT57cEjB0sLntgJRyLF1'
user.assign_attributes(first_name: 'Non-Admin',
                       last_name: 'User',
                       administrator: false
)
user.save!

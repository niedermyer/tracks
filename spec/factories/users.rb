FactoryBot.define do
  factory :user do
    sequence(:first_name) {|sn| "First_#{sn}" }
    sequence(:last_name) {|sn| "Last_#{sn}" }
    sequence(:email) {|sn| "user_#{sn}@example.com" }
    password 'secretSecret123'
    password_confirmation 'secretSecret123'
  end
end

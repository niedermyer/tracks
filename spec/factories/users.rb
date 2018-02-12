FactoryBot.define do
  factory :user do
    sequence(:first_name) {|sn| "First_#{sn}" }
    sequence(:last_name) {|sn| "Last_#{sn}" }
    sequence(:email) {|sn| "user_#{sn}@example.com" }
    password 'secretSecret123'
    password_confirmation 'secretSecret123'
    invitation_accepted_at Time.zone.now
    invitation_token nil

    trait :admin do
      administrator true
    end

    trait :pending_invitation do
      invitation_accepted_at nil
      invitation_created_at Time.zone.now
      invitation_sent_at Time.zone.now
      sequence(:invitation_token) {|sn| "#{sn}evf10al9jtliibbeecoodufbpkpyd12lvq7cw4pnbqh0uzfgbxd5tp7zuxlgtab" }
    end
  end
end

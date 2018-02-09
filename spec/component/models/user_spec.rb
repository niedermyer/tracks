require 'component/component_spec_helper'

RSpec.describe User, type: :model do

  describe 'the users table' do
    subject { User.new }
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:administrator).of_type(:boolean).with_options(null: false, default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, default: "") }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: "") }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer).with_options(null: false, default: 0) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:failed_attempts).of_type(:integer).with_options(null: false, default: 0) }
    it { is_expected.to have_db_column(:locked_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:reset_password_token).unique(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(128) }
    it { is_expected.to allow_value("email@example.com").for(:email) }
    it { is_expected.not_to allow_value("invalidemail").for(:email) }
  end

end

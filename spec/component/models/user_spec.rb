require 'component/component_spec_helper'

RSpec.describe User, type: :model do

  describe 'the users table' do
    subject { User.new }
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:administrator).of_type(:boolean).with_options(null: false, default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:public_id).of_type(:string) }

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

    it { is_expected.to have_db_column(:invitation_token).of_type(:string) }
    it { is_expected.to have_db_column(:invitation_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:invitation_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:invitation_accepted_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:invitation_limit).of_type(:integer) }
    it { is_expected.to have_db_column(:invitations_count).of_type(:integer).with_options(default: 0) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:reset_password_token).unique(true) }
    it { is_expected.to have_db_index(:public_id).unique(true) }
    it { is_expected.to have_db_index(:invitations_count) }
    it { is_expected.to have_db_index(:invitation_token).unique(true) }
    it { is_expected.to have_db_index(:invited_by_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(128) }
    it { is_expected.to allow_value("email@example.com").for(:email) }
    it { is_expected.not_to allow_value("invalidemail").for(:email) }
  end

  describe 'automatically generating #public_id on save' do
    context 'on a new User' do
      let(:user){ build :user }
      it 'is set to a random string' do
        expect { user.save! }.to change { user.public_id }.from(nil).to(an_instance_of(String))
      end
    end
    context 'on an existing user without a public_id' do
      let(:user){ create :user }
      before { user.update_column(:public_id, nil) }
      it 'sets the public_id' do
        expect { user.save }.to change { user.public_id }.from(nil).to(an_instance_of(String))
      end
    end
    context 'on an existing user with a public_id' do
      let(:user){ create :user }
      it 'sets the public_id' do
        # Sanity Check
        expect(user.reload.public_id).to be_present

        expect { user.save }.not_to change { user.public_id }
      end
    end
    describe 'uniqueness of the generated token' do
      before do
        existing_user = create :user
        existing_user.update_column(:public_id, 'TAKEN')
      end

      it 'ensures that the public_id is unique' do
        allow(SecureRandom).to receive(:hex).and_return('TAKEN', 'TAKEN', 'TAKEN', 'UNIQUE')
        new_user = create :user
        expect(new_user.reload.public_id).to eq 'UNIQUE'
      end
    end
  end
end

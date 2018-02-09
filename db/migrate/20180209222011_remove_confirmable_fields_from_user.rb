class RemoveConfirmableFieldsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, column: :confirmation_token

    change_table :users do |t|
      t.remove :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
    end
  end
end

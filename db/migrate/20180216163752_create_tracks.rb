class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
      t.string :import_fingerprint
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end

    add_index :tracks, :user_id
    add_foreign_key :tracks, :users

    add_index :track_segments, :track_id
    add_foreign_key :track_segments, :tracks
  end
end

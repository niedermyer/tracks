class CreateTrackSegments < ActiveRecord::Migration[5.0]
  def change
    create_table :track_segments do |t|
      t.integer :track_id

      t.timestamps
    end

    add_index :track_points, :track_segment_id
    add_foreign_key :track_points, :track_segments
  end
end

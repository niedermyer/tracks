class CreateTrackPoint < ActiveRecord::Migration[5.0]
  def change
    create_table :track_points do |t|
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :elevation_in_meters, precision: 10, scale: 6
      t.datetime :recorded_at
      t.integer :track_segment_id

      t.timestamps
    end
  end
end

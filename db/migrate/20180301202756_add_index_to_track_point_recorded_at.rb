class AddIndexToTrackPointRecordedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :track_points, :recorded_at, order: { recorded_at: :asc }
  end
end

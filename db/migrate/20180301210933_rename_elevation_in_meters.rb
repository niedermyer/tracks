class RenameElevationInMeters < ActiveRecord::Migration[5.0]
  def change
    rename_column :track_points, :elevation_in_meters, :elevation
  end
end

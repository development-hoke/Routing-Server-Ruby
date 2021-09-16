class ChangeDataImagePathToSpot < ActiveRecord::Migration[5.2]
  def change
    change_column :spots, :image_path, :text
  end
end

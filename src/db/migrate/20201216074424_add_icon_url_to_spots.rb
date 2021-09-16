class AddIconUrlToSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :icon_url, :string, comment: "GoogleMapApiのアイコンURL"
  end
end

class ChangeColumnIconUrl < ActiveRecord::Migration[5.2]
  def change
    change_column :spots, :place_id, :string, :after => :site_url, comment: "GoogleMaps API PlaceID"
    change_column :spots, :icon_url, :string, :after => :place_id, comment: "GoogleMaps API アイコンURL"
  end
end

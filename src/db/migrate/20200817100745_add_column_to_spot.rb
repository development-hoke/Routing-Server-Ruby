class AddColumnToSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :img_path, :string, :after => :longitude, comment: "写真の名前（ファイルのパス）"
    add_column :spots, :catergori, :string, :after => :img_path, comment: "カテゴリー名"
    add_column :spots, :service_time, :string, :after => :catergori, comment: "営業時間(9~20)"
    add_column :spots, :tel_no, :string, :after => :service_time, comment: "電話番号"
    add_column :spots, :site_addr, :string, :after => :tel_no, comment: "web siteアドレス"
    add_column :spots, :placeid, :string, :after => :site_addr, limit:32, comment: "GoogleMap ID"
  end
end

class ChangeColumnSpots < ActiveRecord::Migration[5.2]
  def change
    rename_column :spots, :img_path, :image_path
    rename_column :spots, :catergori, :category
    rename_column :spots, :service_time, :opening_hours
    rename_column :spots, :tel_no, :tel
    rename_column :spots, :site_addr, :site_url
    change_column :spots, :image_path, :string, comment: "画像ファイルパス"
    change_column :spots, :category, :string, comment: "カテゴリ"
    change_column :spots, :opening_hours, :string, comment: "営業時間"
    change_column :spots, :tel, :string, comment: "電話番号"
    change_column :spots, :site_url, :string, comment: "サイトURL"
    change_column :spots, :place_id, :string, :after => :site_url, comment: "Google Place ID"
  end
end

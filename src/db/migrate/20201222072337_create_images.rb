class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :spot, foreign_key: true, type: :string, limit: 32, null: false, comment: "スポットID"
      t.text :image_url, null: false, :comment => "画像URL"
      t.datetime :created_at, null: false, comment: "作成日時"
    end

    set_table_comment :images, "スポット画像"
    remove_column :spots, :image_path, :text
  end
end

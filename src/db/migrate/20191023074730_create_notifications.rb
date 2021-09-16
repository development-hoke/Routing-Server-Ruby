# encoding: utf-8
class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications, :comment => "通知" do |t|
      t.string :category, null: false, :comment => "通知種別"
      t.string :title, :comment => "お知らせタイトル"
      t.string :link, :comment => "お知らせ詳細ページURL"
      t.string :user_id, limit: 36, :comment => "フォロー/お気に入り/コメント投稿したユーザーID"
      t.string :comment_id, limit: 32, :comment => "投稿されたコメントID"
      t.string :plan_id, limit: 32, :comment => "お気に入り/コメント投稿されたプランID"
      t.boolean :read, null: false, default: false, :comment => "未読/既読"
      t.datetime :created_at, null: false, :comment => "通知日時"
      t.references :target_user, foreign_key: { to_table: :users }, type: :string, limit: 36, null: false, :comment => "通知を受け取るユーザー"
    end

    remove_column_comment :spots, :longitude
    set_column_comment :spots, :longitude, "経度"
  end
end

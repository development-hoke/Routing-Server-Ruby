# encoding: utf-8
class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings, id: false do |t|
      t.references :user, primary_key: true, foreign_key: true, type: :string, limit: 36, null: false
      t.string :notification_follow, null: false, default: true, :comment => "フォロー通知を受け取るか"
      t.string :notification_like, null: false, default: true, :comment => "お気に入り通知を受け取るか"
      t.string :notification_comment, null: false, default: true, :comment => "コメント通知を受け取るか"
    end
  end
end

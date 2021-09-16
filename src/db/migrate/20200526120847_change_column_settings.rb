class ChangeColumnSettings < ActiveRecord::Migration[5.2]
  def change
    change_column :settings, :notification_follow, :boolean, default: true, null: false, comment: "フォロー通知を受け取るか"
    change_column :settings, :notification_like, :boolean, default: true, null: false, comment: "お気に入り通知を受け取るか"
    change_column :settings, :notification_comment, :boolean, default: true, null: false, comment: "コメント通知を受け取るか"
  end
end

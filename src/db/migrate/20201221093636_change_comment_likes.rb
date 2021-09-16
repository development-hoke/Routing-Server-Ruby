class ChangeCommentLikes < ActiveRecord::Migration[5.2]
  def change
    set_table_comment :likes, "いいね"
    set_column_comment :likes, :user_id, "ユーザーID(いいねしたユーザー)"
    set_column_comment :likes, :plan_id, "デートプランID(いいねされたプラン)"
    set_column_comment :likes, :created_at, "いいね日時"
    set_column_comment :notifications, :user_id, "フォロー/いいね/コメント投稿したユーザーID"
    set_column_comment :notifications, :plan_id, "いいね/コメント投稿されたプランID"
    set_column_comment :settings, :notification_like, "いいね通知を受け取るか"
  end
end

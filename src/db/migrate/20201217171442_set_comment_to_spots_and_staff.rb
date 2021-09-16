class SetCommentToSpotsAndStaff < ActiveRecord::Migration[5.2]
  def change
    set_table_comment :staff, "運営スタッフ"
    set_column_comment :staff, :name, "スタッフ名"
    set_column_comment :staff, :password_digest, "暗号化パスワード"
    set_column_comment :staff, :session_key, "セッションキー"
    set_column_comment :staff, :created_at, "作成日時"
    set_column_comment :staff, :updated_at, "更新日時"
    set_table_comment :routes, "プランに含まれるスポット"
    set_column_comment :routes, :plan_id, "デートプランID"
    set_column_comment :routes, :spot_id, "デートスポットID"
    set_column_comment :routes, :created_at, "作成日時"
    set_column_comment :routes, :updated_at, "更新日時"
    set_column_comment :users, :status, "ユーザーステータス"
    set_column_comment :plans, :status, "プランステータス"
    remove_column_comment :plans, :id
    remove_column_comment :users, :id
    remove_column_comment :comments, :id
    remove_column_comment :likes, :id
    remove_column_comment :follows, :id
    remove_column_comment :histories, :id
  end
end

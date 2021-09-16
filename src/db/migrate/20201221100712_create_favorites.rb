class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true, type: :string, limit: 36, null: false, comment: "ユーザーID(お気に入りしたユーザー)"
      t.references :plan, foreign_key: true, type: :string, limit: 32, null: false, comment: "デートプランID(お気に入りされたプラン)"
      t.datetime :created_at, null: false, comment: "お気に入り日時"
    end

    set_table_comment :favorites, "お気に入り"
  end
end

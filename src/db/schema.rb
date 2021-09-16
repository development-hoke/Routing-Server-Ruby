# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_27_173024) do

  create_table "comments", id: :string, limit: 32, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "コメント", force: :cascade do |t|
    t.text "comment", null: false, comment: "コメント内容"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID(コメントしたユーザー)"
    t.string "plan_id", limit: 32, null: false, comment: "デートプランID(コメントされたプラン)"
    t.index ["plan_id"], name: "index_comments_on_plan_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "お気に入り", force: :cascade do |t|
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID(お気に入りしたユーザー)"
    t.string "plan_id", limit: 32, null: false, comment: "デートプランID(お気に入りされたプラン)"
    t.datetime "created_at", null: false, comment: "お気に入り日時"
    t.index ["plan_id"], name: "index_favorites_on_plan_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "follows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "フォロー", force: :cascade do |t|
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID(フォローしたユーザー)"
    t.string "follow_user_id", limit: 36, null: false, comment: "ユーザーID(フォローされたユーザー)"
    t.datetime "created_at", null: false, comment: "フォロー日時"
    t.index ["follow_user_id"], name: "index_follows_on_follow_user_id"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "検索履歴", force: :cascade do |t|
    t.string "word", null: false, comment: "検索ワード"
    t.datetime "created_at", null: false, comment: "検索日時"
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "スポット画像", force: :cascade do |t|
    t.string "spot_id", limit: 32, null: false, comment: "スポットID"
    t.text "image_url", null: false, comment: "画像URL"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.index ["spot_id"], name: "index_images_on_spot_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "いいね", force: :cascade do |t|
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID(いいねしたユーザー)"
    t.string "plan_id", limit: 32, null: false, comment: "デートプランID(いいねされたプラン)"
    t.datetime "created_at", null: false, comment: "いいね日時"
    t.index ["plan_id"], name: "index_likes_on_plan_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "通知", force: :cascade do |t|
    t.string "category", null: false, comment: "通知種別"
    t.string "title", comment: "お知らせタイトル"
    t.string "link", comment: "お知らせ詳細ページURL"
    t.string "user_id", limit: 36, comment: "フォロー/いいね/コメント投稿したユーザーID"
    t.string "comment_id", limit: 32, comment: "投稿されたコメントID"
    t.string "plan_id", limit: 32, comment: "いいね/コメント投稿されたプランID"
    t.boolean "read", default: false, null: false, comment: "未読/既読"
    t.datetime "created_at", null: false, comment: "通知日時"
    t.string "target_user_id", limit: 36, null: false, comment: "通知を受け取るユーザーID"
    t.index ["target_user_id"], name: "index_notifications_on_target_user_id"
  end

  create_table "plans", id: :string, limit: 32, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "デートプラン", force: :cascade do |t|
    t.string "title", null: false, comment: "デートプランタイトル"
    t.text "description", comment: "説明"
    t.string "date", comment: "デート予定日"
    t.string "transportation", comment: "交通手段"
    t.integer "need_time", comment: "所要時間"
    t.string "status", null: false, comment: "プランステータス"
    t.string "datetime_status", null: false, comment: "投稿時日時表示ステータス"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "Q&A", force: :cascade do |t|
    t.text "question", null: false, comment: "質問内容"
    t.text "answer", comment: "回答内容"
    t.boolean "resolved", default: false, null: false, comment: "解決済みかどうか"
    t.boolean "faq", default: false, null: false, comment: "FAQかどうか"
    t.datetime "asked_at", null: false, comment: "質問日時"
    t.datetime "answered_at", comment: "回答日時"
    t.string "user_id", limit: 36, null: false, comment: "質問者のユーザーID"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "routes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "プランに含まれるスポット", force: :cascade do |t|
    t.string "plan_id", limit: 32, null: false, comment: "デートプランID"
    t.string "spot_id", limit: 32, null: false, comment: "デートスポットID"
    t.integer "order", limit: 1, null: false, comment: "順番"
    t.integer "need_time", comment: "所要時間"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["plan_id"], name: "index_routes_on_plan_id"
    t.index ["spot_id"], name: "index_routes_on_spot_id"
  end

  create_table "settings", primary_key: "user_id", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザー設定", force: :cascade do |t|
    t.boolean "notification_follow", default: true, null: false, comment: "フォロー通知を受け取るか"
    t.boolean "notification_like", default: true, null: false, comment: "いいね通知を受け取るか"
    t.boolean "notification_comment", default: true, null: false, comment: "コメント通知を受け取るか"
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "spots", id: :string, limit: 32, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "デートスポット", force: :cascade do |t|
    t.string "spot_type"
    t.string "name", null: false, comment: "スポット名"
    t.text "description", comment: "説明"
    t.float "latitude", limit: 53, null: false, comment: "緯度"
    t.float "longitude", limit: 53, null: false, comment: "経度"
    t.string "category", comment: "カテゴリ"
    t.string "opening_hours", comment: "営業時間"
    t.string "tel", comment: "電話番号"
    t.string "site_url", comment: "サイトURL"
    t.string "place_id", comment: "GoogleMaps API PlaceID"
    t.string "icon_url", comment: "GoogleMaps API アイコンURL"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "plan_id", limit: 32, comment: "デートプランID"
    t.string "address", comment: "住所"
  end

  create_table "staff", id: :string, limit: 8, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "運営スタッフ", force: :cascade do |t|
    t.string "name", null: false, comment: "スタッフ名"
    t.string "password_digest", null: false, comment: "暗号化パスワード"
    t.string "session_key", limit: 32, comment: "セッションキー"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "users", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザー", force: :cascade do |t|
    t.string "name", null: false, comment: "ユーザー名"
    t.string "onedate_id", comment: "1DID"
    t.string "profile", comment: "自己紹介文"
    t.string "sex", null: false, comment: "性別"
    t.integer "age", null: false, comment: "年齢"
    t.string "area", null: false, comment: "エリア"
    t.string "address", comment: "住所"
    t.string "mail_address", null: false, comment: "メールアドレス"
    t.string "user_attr", null: false, comment: "ユーザー属性"
    t.string "status", null: false, comment: "ユーザーステータス"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "password_digest", null: false, comment: "暗号化パスワード"
    t.string "image_url"
    t.integer "login_num", null: false, comment: "ログイン数"
  end

  create_table "logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザーログ", force: :cascade do |t|
    t.string "user_id", limit: 36, null: false, comment: "ユーザーID"
    t.datetime "created_at", null: false, comment: "いいね日時"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  add_foreign_key "comments", "plans"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "plans"
  add_foreign_key "favorites", "users"
  add_foreign_key "follows", "users"
  add_foreign_key "follows", "users", column: "follow_user_id"
  add_foreign_key "histories", "users"
  add_foreign_key "images", "spots"
  add_foreign_key "likes", "plans"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users", column: "target_user_id"
  add_foreign_key "plans", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "routes", "plans"
  add_foreign_key "routes", "spots"
  add_foreign_key "settings", "users"
  add_foreign_key "logs", "users"
end

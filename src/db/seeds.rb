# encoding: utf-8
# ------------------------------
# サンプルデータ
# ------------------------------

# ユーザー
master_password_digest = BCrypt::Password.create("password")
hanako_password_digest = BCrypt::Password.create("password")
taro_password_digest = BCrypt::Password.create("password")
master = User.create!(name: "デートマスター", onedate_id: "datemaster", sex: "man", age: 25, area: "tokyo", mail_address: "master@onedate.com", user_attr: "official", status: "public", password_digest: master_password_digest, login_num: 1)
hanako = User.create!(name: "山田花子", onedate_id: "hanakoyamada", sex: "woman", age: 23, area: "osaka", mail_address: "yamada@onedate.com", user_attr: "ordinary", status: "public", password_digest: hanako_password_digest, login_num: 2)
taro = User.create!(name: "田中太郎", onedate_id: "tarotanaka", sex: "man", age: 21, area: "fukuoka", mail_address: "tanaka@onedate.com", user_attr: "ordinary", status: "public", password_digest: taro_password_digest, login_num: 3)

# 仮ユーザーのIDは決め打ちにしておく
master.id = "0000aaaa-1111-bbbb-2222-cccc3333dddd"; master.save
hanako.id = "4444eeee-5555-ffff-6666-gggg7777hhhh"; hanako.save
taro.id = "8888iiii-9999-jjjj-0000-kkkk1111llll"; taro.save

# ユーザー設定
Setting.create!(user_id: master.id)
Setting.create!(user_id: hanako.id)
Setting.create!(user_id: taro.id)

# ログ設定
Log.create!(user_id: master.id)
Log.create!(user_id: hanako.id)
Log.create!(user_id: taro.id)
Log.create!(user_id: taro.id)
Log.create!(user_id: hanako.id)
Log.create!(user_id: taro.id)
# デートプラン
master_plan1 = Plan.create!(title: "今週のおすすめデート", description: "7月のオススメコースです！", date: "2019-07-01", transportation: ["train", "walk"].to_s, need_time: 500, status: "public", datetime_status: "public", user_id: master.id)
hanako_plan1 = Plan.create!(title: "大阪デート", description: "おおさかデートやで！", date: "2019-07-10", transportation: ["train", "walk"].to_s, need_time: 400, status: "public", datetime_status: "public", user_id: hanako.id)
taro_plan1 = Plan.create!(title: "博多食べ歩きデート", description: "おいしいもの食べる(^^)", date: "2019-07-20", transportation: ["car", "walk"].to_s, need_time: 300, status: "public", datetime_status: "public", user_id: taro.id)

# デートスポット
spot1 = Spot.create!(name: "東京タワー", description: "東京スカイツリー", latitude: 35.6585805, longitude: 139.7432442, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: master_plan1.id)
spot2 = Spot.create!(name: "チームラボボーダレス", description: "チームラボボーダレス", latitude: 35.6263868, longitude: 139.7809164, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: hanako_plan1.id)
spot3 = Spot.create!(name: "浅草ホッピー通り", description: "浅草ホッピー通り", latitude: 35.7130994, longitude: 139.7920882, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: taro_plan1.id)
spot4 = Spot.create!(name: "海遊館", description: "海遊館", latitude: 34.6545182, longitude: 135.4267758, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: taro_plan1.id)
spot5 = Spot.create!(name: "ハルカス300(展望台)", description: "ハルカス300(展望台)", latitude: 35.1727542, longitude: 136.5410337, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: master_plan1.id)
spot6 = Spot.create!(name: "かに道楽道頓堀店", description: "かに道楽道頓堀店", latitude: 35.1624272, longitude: 136.5410204, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: master_plan1.id)
spot7 = Spot.create!(name: "大濠公園", description: "大濠公園", latitude: 33.5862702, longitude: 130.3723765, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: hanako_plan1.id)
spot8 = Spot.create!(name: "福岡タワー", description: "福岡タワー", latitude: 33.5932846, longitude: 130.3493213, category: "xxx", opening_hours: "10:00-19:00", tel: "08099999999", place_id: "xxx", icon_url: "https://xxx.com/icon/yyy.png", spot_type: "ok", plan_id: hanako_plan1.id)

# スポット画像
Image.create!(spot_id: spot1.id, image_url: "https://xxx.com/photo/zzz/1.png")
Image.create!(spot_id: spot6.id, image_url: "https://xxx.com/photo/zzz/2.png")
Image.create!(spot_id: spot3.id, image_url: "https://xxx.com/photo/zzz/3.png")
Image.create!(spot_id: spot2.id, image_url: "https://xxx.com/photo/zzz.png")
Image.create!(spot_id: spot4.id, image_url: "https://xxx.com/photo/zzz.png")
Image.create!(spot_id: spot7.id, image_url: "https://xxx.com/photo/zzz.png")

# プラントスポットの紐付け
Route.create!(plan_id: master_plan1.id, spot_id: spot1.id, order: 1, need_time: 120)
Route.create!(plan_id: master_plan1.id, spot_id: spot2.id, order: 2, need_time: 120)
Route.create!(plan_id: master_plan1.id, spot_id: spot3.id, order: 3, need_time: 180)
Route.create!(plan_id: hanako_plan1.id, spot_id: spot4.id, order: 1, need_time: 180)
Route.create!(plan_id: hanako_plan1.id, spot_id: spot5.id, order: 2, need_time: 180)
Route.create!(plan_id: hanako_plan1.id, spot_id: spot6.id, order: 3, need_time: 180)
Route.create!(plan_id: taro_plan1.id, spot_id: spot7.id, order: 1, need_time: 180)
Route.create!(plan_id: taro_plan1.id, spot_id: spot8.id, order: 2, need_time: 180)

# いいね
Like.create!(user_id: hanako.id, plan_id: master_plan1.id)
Like.create!(user_id: taro.id, plan_id: master_plan1.id)
Like.create!(user_id: taro.id, plan_id: hanako_plan1.id)
Notification.create!(category: "like", user_id: hanako.id, plan_id: master_plan1.id, target_user_id: master_plan1.user_id)
Notification.create!(category: "like", user_id: taro.id, plan_id: master_plan1.id, target_user_id: master_plan1.user_id)
Notification.create!(category: "like", user_id: taro.id, plan_id: hanako_plan1.id, target_user_id: hanako_plan1.user_id)

# お気に入り
Favorite.create!(user_id: master.id, plan_id: hanako_plan1.id)
Favorite.create!(user_id: master.id, plan_id: taro_plan1.id)

# コメント
master_plan1_comment1 = Comment.create!(comment: "楽しそう！", user_id: hanako.id, plan_id: master_plan1.id)
master_plan1_comment2 = Comment.create!(comment: "行ってみたい！", user_id: taro.id, plan_id: master_plan1.id)
taro_plan1_comment1 = Comment.create!(comment: "このコースでデートしたことある〜", user_id: hanako.id, plan_id: taro_plan1.id)
Notification.create!(category: "comment", user_id: hanako.id, comment_id: master_plan1_comment1.id, plan_id: master_plan1.id, target_user_id: master_plan1.user_id)
Notification.create!(category: "comment", user_id: taro.id, comment_id: master_plan1_comment2.id, plan_id: master_plan1.id, target_user_id: master_plan1.user_id)
Notification.create!(category: "comment", user_id: hanako.id, comment_id: taro_plan1_comment1.id, plan_id: taro_plan1.id, target_user_id: taro_plan1.user_id)

# フォロー
Follow.create!(user_id: hanako.id, follow_user_id: master.id)
Follow.create!(user_id: taro.id, follow_user_id: master.id)
Notification.create!(category: "follow", user_id: hanako.id, target_user_id: master.id)
Notification.create!(category: "follow", user_id: taro.id, target_user_id: master.id)

# 検索履歴
History.create!(word: "おすすめ", user_id: master.id)
History.create!(word: "食べ歩き", user_id: master.id)

# 運営からのお知らせ
Notification.create!(category: "information", title: "キャンペーンのお知らせ", link: "http://hoge.com/campaign", target_user_id: master.id)
Notification.create!(category: "information", title: "1Dateへようこそ", link: "http://hoge.com/welcome", target_user_id: master.id)

# よくある質問
Question.create!(question: "プロフィールの内容を変更したいです。", answer: "設定＞プロフィール編集 より変更が可能です。", resolved: true, faq: true, asked_at: Time.now, answered_at: Time.now, user_id: master.id)
Question.create!(question: "プランの作成方法がわかりません。", answer: "設定＞プラン作成方法 を参照してください。", resolved: true, faq: true, asked_at: Time.now, answered_at: Time.now, user_id: master.id)
Question.create!(question: "退会するにはどうしたら良いですか？", answer: "お問い合わせフォームにて退会希望の旨を記載の上送信してください。", resolved: true, faq: true, asked_at: Time.now, answered_at: Time.now, user_id: master.id)

# スタッフ
staff_password_digest = BCrypt::Password.create("password")
Staff.create!(id: "admin", name: "スタッフA", password_digest: staff_password_digest, session_key: SecureRandom.hex)

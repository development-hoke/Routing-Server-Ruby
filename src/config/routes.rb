# encoding: utf-8
# ------------------------------
# ルーティング
# ------------------------------
Rails.application.routes.draw do

  # ------------------------------------------------------------------------------------------
  # App API
  # ------------------------------------------------------------------------------------------
  scope module: :public, defaults: { format: "json" } do
    # [U-1] POST /users ユーザー登録
    # [U-2] GET /users/:id ユーザー情報取得
    # [U-3] PUT /users/:id プロフィール編集
    # [U-4] DELETE /users/:id ユーザー退会
    resources :users, only: [:create, :show, :update, :destroy] do
      # [L-1] GET /users/:user_id/likes いいねしたデートプラン一覧取得
      resources :likes, only: [:index]
      # [FV-1] GET /users/:user_id/favorites お気に入りしたデートプラン一覧取得
      resources :favorites, only: [:index]
      # [F-1] GET /users/:user_id/follows フォローリスト取得
      resources :follows, only: [:index]
      # [N-1] GET /users/:user_id/notifications 通知一覧取得
      # [N-5] PUT /users/:user_id/notifications/:id 通知既読
      resources :notifications, only: [:index, :update] do
        collection do
          # [N-2] GET /users/:user_id/notifications/settings 通知設定取得
          get :settings, action: "get_settings"
          # [N-3] PUT /users/:user_id/notifications/settings 通知設定編集
          put :settings, action: "update_settings"
        end
      end
    end

    # [P-1] GET /plans デートプラン一覧取得
    # [P-2] POST /plans デートプラン作成
    # [P-3] GET /plans/:id デートプラン詳細取得
    # [P-4] PUT /plans/:id デートプラン編集
    # [P-5] DELETE /plans/:id デートプラン削除
    resources :plans, only: [:index, :create, :show, :update, :destroy] do
      # [L-2] POST /plans/:plan_id/likes プランのいいね登録
      resources :likes, only: [:create]
      # [FV-2] POST /plans/:plan_id/favorites プランのお気に入り登録
      resources :favorites, only: [:create]
      # [C-1] GET /plans/:plan_id/comments コメント一覧取得
      # [C-2] POST /plans/:plan_id/comments コメント投稿
      # [C-3] DELETE /plans/:plan_id/comments/:id コメント削除
      resources :comments, only: [:index, :create, :destroy]

      collection do
        # [P-6] GET /plans/search デートプラン検索
        get :search
      end
    end

    # [S-1] POST /spots スポット作成
    resources :spots, only: [:create] do
      collection do
        # [S-2] GET /spots/search スポット検索
        get :search
      end
    end

    # [Q-1] POST /questions 質問投稿
    resources :questions, only: [:create] do
      collection do
        # [Q-2] GET /plans/faq よくある質問一覧取得
        get :faq
      end
    end

    # [U-5] PUT /users/:user_id/password パスワード変更
    put "/users/:user_id/password", controller: "users", action: "update_password"
    # [U-6] PUT /users/:user_id/1did 1DID更新
    put "/users/:user_id/1did", controller: "users", action: "update_1did"
    # [U-7] POST /users/login アプリにログイン
    post "/users/login", controller: "users", action: "login"
    # [U-8] PUT /users/:user_id/status ユーザー公開・非公開
    put "/users/:user_id/status", controller: "users", action: "update_status"
    # [H-1] GET /plans/search/history 検索履歴一覧取得
    get "/plans/search/history", controller: "histories", action: "index"
    # [H-2] DELETE /plans/search/history/:history_id 検索履歴削除
    delete "/plans/search/history/:history_id", controller: "histories", action: "destroy"
    # [P-7] PUT /users/:user_id/status デートプラン公開・非公開
    put "/plans/:plan_id/status", controller: "plans", action: "update_status"
    # [P-8] PUT /users/:user_id/datetime_status デートプラン日時公開・非公開
    put "/plans/:plan_id/datetime_status", controller: "plans", action: "update_datetime_status"
    # [L-3] DELETE /plans/:plan_id/likes プランのいいね解除
    delete "/plans/:plan_id/likes", controller: "likes", action: "destroy"
    # [L-4] GET /plans/:plan_id/likes プランにいいねしたユーザー一覧取得
    get "/plans/:plan_id/likes", controller: "likes", action: "index_users"
    # [FV-3] DELETE /plans/:plan_id/favorites プランのお気に入り解除
    delete "/plans/:plan_id/favorites", controller: "favorites", action: "destroy"
    # [FV-4] GET /plans/:plan_id/favorites プランをお気に入り登録したユーザー一覧取得
    get "/plans/:plan_id/favorites", controller: "favorites", action: "index_users"
    # [F-2] GET /users/:user_id/followers フォロワーリスト取得
    get "/users/:user_id/followers", controller: "follows", action: "index_followers"
    # [F-3] POST /users/:follow_user_id/followers アカウントフォロー
    post "/users/:follow_user_id/followers", controller: "follows", action: "create"
    # [F-4] DELETE /users/:follow_user_id/followers アカウントフォロー解除
    delete "/users/:follow_user_id/followers", controller: "follows", action: "destroy"
    # [N-2] GET /information 運営からのお知らせ一覧取得
    get "/information", controller: "notifications", action: "information"
    # [U-9] POST /users/profimage プロフィール画像アップロードAPI
    post "/users/:user_id/profimage", controller: "users", action: "upload_profimage"
    # [U-10] GET /users/profimage プロフィール画像表示API
    get "/users/:user_id/profimage", controller: "users", action: "show_profimage"
  end

  # ------------------------------------------------------------------------------------------
  # Admin API
  # ------------------------------------------------------------------------------------------
  namespace :admin, defaults: { format: "json" } do
    # [AU-1] GET /admin/users ユーザー一覧取得・検索
    # [AU-2] GET /admin/users/:id ユーザー詳細取得
    resources :users, only: [:index, :show]

    # [AP-1] GET /admin/plans デートプラン一覧取得・検索
    # [AP-2] GET /admin/plans/:id デートプラン詳細取得
    resources :plans, only: [:index, :show]

    # [AS-1] GET /admin/spots デートプラン一覧取得・検索
    # [AS-2] GET /admin/spots/:id デートプラン詳細取得
    resources :spots, only: [:index, :show]
    
    # [AQ-2] PUT /admin/questions/:id 質問回答登録
    resources :questions, only: [:update]

    # [AU-3] PUT /admin/users/:id/attribute ユーザー属性編集
    put "/users/:user_id/attribute", controller: "users", action: "update_attribute"
    # [AN-1] POST /admin/information 運営からのお知らせ送信
    post "/information", controller: "notifications", action: "create"
    # [AQ-3] PUT /admin/questions/:question_id/faq よくある質問に登録
    put "/questions/:question_id/faq", controller: "questions", action: "faq"
    # [AL-1] POST /admin/staff/login 管理画面ログイン
    post "/staff/login", controller: "staff", action: "login"
    # [AL-1] POST /admin/staff/login 管理画面ログアウト
    put "/staff/logout", controller: "staff", action: "logout"
  end

  # Root
  root "application#index"

  # 存在しないURLのエラーハンドリング
  get "*path", controller: "application", action: "not_found_error"
  post "*path", controller: "application", action: "not_found_error"
  put "*path", controller: "application", action: "not_found_error"
  delete "*path", controller: "application", action: "not_found_error"
end

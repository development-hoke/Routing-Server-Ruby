# encoding: utf-8
# ------------------------------
# レスポンス生成モジュール
# ------------------------------
module RenderCommonResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # 200 Success
  # ------------------------------
  def render_success(class_name, action_name, id)
    case class_name
    when :user then message_class = "ユーザー"
    when :plan then message_class = "デートプラン"
    when :spot then message_class = "スポット"
    when :like then message_class = "いいね"
    when :favorite then message_class = "お気に入り"
    when :comment then message_class = "コメント"
    when :follow then message_class = "フォロー"
    when :history then message_class = "検索履歴"
    when :notification then message_class = "通知"
    when :question then message_class = "質問"
    when :settings then message_class = "ユーザー設定"
    when :staff then message_class = "スタッフ"
    else message_class = class_name
    end

    case action_name
    when :create then message_action = "登録"
    when :update then message_action = "更新"
    when :delete then message_action = "削除"
    else message_action = action_name
    end

    render status: 200, json: {
      code: 200,
      message: "#{message_class}の#{message_action}に成功しました",
      id: id,
    }
  end

  # ------------------------------
  # 400 Bad Request
  # ------------------------------
  def render_validation_error(error_message_list)
    render status: 400, json: {
      code: 400,
      message: "パラメータが不正です",
      detail_message: error_message_list,
    }
  end

  # ------------------------------
  # 400 Bad Request
  # ------------------------------
  def render_no_target(error_message)
    case error_message
    when "Couldn't find User" then detail_message = "ユーザーが見つかりません"
    when "Couldn't find Plan" then detail_message = "デートプランが見つかりません"
    when "Couldn't find Spot" then detail_message = "スポットが見つかりません"
    when "Couldn't find Like" then detail_message = "いいねが見つかりません"
    when "Couldn't find Favorite" then detail_message = "お気に入りが見つかりません"
    when "Couldn't find Comment" then detail_message = "コメントが見つかりません"
    when "Couldn't find Follow" then detail_message = "フォローが見つかりません"
    when "Couldn't find History" then detail_message = "検索履歴が見つかりません"
    when "Couldn't find Notification" then detail_message = "通知が見つかりません"
    when "Couldn't find Question" then detail_message = "質問が見つかりません"
    when "Couldn't find Setting" then detail_message = "ユーザー設定が見つかりません"
    when "Couldn't find Staff" then detail_message = "スタッフが見つかりません"
    else detail_message = "対象が見つかりません"
    end

    render status: 400, json: {
      code: 400,
      message: "パラメータが不正です",
      detail_message: Array.new.push(detail_message),
    }
  end

  # ------------------------------
  # 403 Forbidden
  # ------------------------------
  def render_forbidden
    render status: 403, json: { code: 403, message: "認証に失敗しました" }
  end

  # ------------------------------
  # 404 Not Found
  # ------------------------------
  def render_not_found
    render status: 404, json: { code: 404, message: "存在しないURLです" }
  end

  # ------------------------------
  # 500 Internal Server Error
  # ------------------------------
  def render_internal_server_error(error_message)
    render status: 500, json: {
      code: 500,
      message: "システムエラーが発生しました",
      detail_message: error_message,
    }
  end
end

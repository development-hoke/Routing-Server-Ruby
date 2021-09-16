# encoding: utf-8
# ------------------------------
# 通知コントローラー
# ------------------------------
class Public::NotificationsController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include RenderNotificationsResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [N-1] 通知一覧取得
  # GET /users/:user_id/notifications
  # ------------------------------
  def index
    target_user = User.find_by!(id: params[:user_id])
    unread_count = Notification
      .where.not(category: "information")
      .where(target_user_id: target_user.id, read: false)
      .count

    notifications = Notification
      .where.not(category: "information")
      .where(target_user_id: target_user.id)
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: :desc)

    # 詳細情報の取得
    additional_items_map = Hash.new
    notifications.each do |notification|
      user = User.find_by(id: notification.user_id)
      plan = Plan.find_by(id: notification.plan_id)
      comment = Comment.find_by(id: notification.comment_id)

      user_id = ""
      user_name = ""
      plan_id = ""
      plan_title = ""
      plan_comment = ""

      if user.present?
        user_id = user.id
        user_name = user.name
      end

      if plan.present?
        plan_id = plan.id
        plan_title = plan.title
      end

      if comment.present?
        plan_comment = comment.comment
      end

      additional_items_map.store(
        notification.id,
        {
          user_id: user_id,
          user_name: user_name,
          plan_id: plan_id,
          plan_title: plan_title,
          plan_comment: plan_comment,
        }
      )
    end

    render_notification_list(notifications, additional_items_map, unread_count)
  end

  # ------------------------------
  # [N-2] 通知設定取得
  # GET /users/:user_id/notifications/settings
  # ------------------------------
  def get_settings
    target_user = User.find_by!(id: params[:user_id])

    # ユーザー登録時にデフォルト設定で登録するため起こり得ないがもし設定を取得できなければエラー
    setting = Setting.find_by!(user_id: target_user.id)

    render_notification_setting(setting)
  end

  # ------------------------------
  # [N-3] 通知設定編集
  # PUT /users/:user_id/notifications/settings
  # ------------------------------
  def update_settings
    target_user = User.find_by!(id: params[:user_id])

    # ユーザー登録時にデフォルト設定で登録するため起こり得ないがもし設定を取得できなければエラー
    setting = Setting.find_by!(user_id: target_user.id)

    # リクエストされたパラメータのみ更新する
    if notification_setting_params[:follow].nil?
      notification_follow = setting.notification_follow
    else
      notification_follow = notification_setting_params[:follow]
    end

    if notification_setting_params[:like].nil?
      notification_like = setting.notification_like
    else
      notification_like = notification_setting_params[:like]
    end

    if notification_setting_params[:comment].nil?
      notification_comment = setting.notification_comment
    else
      notification_commetn = notification_setting_params[:comment]
    end

    if setting.update(
      notification_follow: notification_follow,
      notification_like: notification_like,
      notification_comment: notification_comment,
    )
      render_success(:settings, :update, target_user.id)
    else
      render_validation_error(setting.errors.full_messages)
    end
  end

  # ------------------------------
  # [N-4] 運営からのお知らせ一覧取得
  # GET /information
  # ------------------------------
  def information
    target_user = User.find_by!(id: params[:user_id])
    unread_count = Notification
      .where(category: "information", target_user_id: target_user.id, read: false)
      .count

    information = Notification
      .where(category: "information", target_user_id: target_user.id)
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: :desc)

    render_information_list(information, unread_count)
  end

  # 通知設定編集リクエストパラメータ
  def notification_setting_params
    params.permit(:like, :follow, :comment)
  end

  # ------------------------------
  # [N-5] 通知既読
  # PUT /users/:user_id/notifications/:id
  # ------------------------------
  def update
    target_notification = Notification.find_by!(id: params[:id])
    target_user = User.find_by!(id: params[:user_id])

    if target_notification.update(
      read: true,
    )
      render_success(:notification, :update, target_notification.id)
    else
      render_validation_error(notification.errors.full_messages)
    end
  end
end

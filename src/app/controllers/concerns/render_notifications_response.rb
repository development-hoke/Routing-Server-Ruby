# encoding: utf-8
# ------------------------------
# 通知APIレスポンス生成モジュール
# ------------------------------
module RenderNotificationsResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # 通知一覧取得レスポンス
  # ------------------------------
  def render_notification_list(notifications, additional_items_map, unread_count)
    notification_list = Array.new

    notifications.each do |n|
      additional_items = additional_items_map[n.id]

      notification = {
        notification_id: n.id,
        notification_category: n.category,
        notification_date: n.created_at,
        plan_id: additional_items[:plan_id],
        plan_title: additional_items[:plan_title],
        plan_comment: additional_items[:plan_comment],
        user_id: additional_items[:user_id],
        user_name: additional_items[:user_name],
        user_image_url: "/icons/" + additional_items[:user_id] + ".jpg",
        read: n.read,
      }

      notification_list.push(notification)
    end

    render json: {
      unread_count: unread_count,
      notification_list: notification_list,
    }
  end

  # ------------------------------
  # 通知設定取得レスポンス
  # ------------------------------
  def render_notification_setting(setting)
    render json: {
      like: setting.notification_like,
      follow: setting.notification_follow,
      comment: setting.notification_comment,
    }
  end

  # ------------------------------
  # お知らせ一覧取得レスポンス
  # ------------------------------
  def render_information_list(information, unread_count)
    information_list = information.map { |i|
      {
        notification_id: i.id,
        notification_date: i.created_at,
        title: i.title,
        link: i.link,
        read: i.read,
      }
    }

    render json: {
      unread_count: unread_count,
      information_list: information_list,
    }
  end

  # ------------------------------
  # お知らせ送信レスポンス
  # ------------------------------
  def render_send_information(ids)
    render status: 200, json: {
      code: 200,
      message: "お知らせを送信しました",
      ids: ids,
    }
  end
end

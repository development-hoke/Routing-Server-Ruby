# encoding: utf-8
# ------------------------------
# [管理用] 通知コントローラー
# ------------------------------
class Admin::NotificationsController < Admin::ApplicationController
  include RenderNotificationsResponse

  # ------------------------------
  # [AD-1] 運営からのお知らせ送信
  # POST /admin/information
  # ------------------------------
  def create
    errors = Array.new

    if information_params[:title].blank?
      errors.push("Titleは必須です")
    end

    if information_params[:link].blank?
      errors.push("Linkは必須です")
    end

    # TODO TitleとLinkの文字数バリデーション

    unless errors.blank?
      render_validation_error(errors) and return
    end

    # ユーザーIDを指定した場合は当該ユーザーにのみ送信
    if params[:user_id].present?
      target_user = User.find_by!(id: params[:user_id])

      Notification.create(
        category: "information",
        title: information_params[:title],
        link: information_params[:link],
        target_user_id: target_user.id,
      )

      render_send_information([target_user.id]) and return
    end

    # ユーザーIDを指定しない場合は全ユーザーが対象
    target_users = User.all
    target_users.each do |target_user|
      Notification.create(
        category: "information",
        title: information_params[:title],
        link: information_params[:link],
        target_user_id: target_user.id,
      )
    end

    render_send_information(target_users.map(&:id))
  end

  private

  # 運営からのお知らせ送信リクエストボディ
  def information_params
    params.permit(:title, :link)
  end
end

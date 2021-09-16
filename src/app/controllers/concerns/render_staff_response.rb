# encoding: utf-8
# ------------------------------
# [管理画面] スタッフAPIレスポンス生成モジュール
# ------------------------------
module RenderStaffResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # 管理画面ログインレスポンス
  # ------------------------------
  def render_login_staff(staff)
    render json: {
      staff_id: staff.id,
      name: staff.name,
      session_key: staff.session_key,
    }
  end
end

# encoding: utf-8
# ------------------------------
# Admin 基底コントローラー
# ------------------------------
class Admin::ApplicationController < ApplicationController
  before_action :check_session_key
  skip_before_action :check_session_key, only: [:login]

  private

  # ------------------------------
  # 管理画面ログインチェック
  # ------------------------------
  def check_session_key
    session_key = request.headers["HTTP_SESSION_KEY"]

    unless session_key.present?
      render_validation_error(Array.new.push("Session Keyは必須です")) and return
    end

    staff = Staff.find_by(session_key: session_key)

    unless staff.present?
      render_forbidden and return
    end
  end
end

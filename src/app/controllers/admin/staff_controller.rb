# encoding: utf-8
# ------------------------------
# [管理用] スタッフコントローラー
# ------------------------------
class Admin::StaffController < Admin::ApplicationController
  include ValidateCondition
  include RenderStaffResponse

  # ------------------------------
  # [AL-1] 管理画面ログイン
  # POST /admin/staff/login
  # ------------------------------
  def login
    unless params[:id].blank?
      staff = Staff.find_by!(id: params[:id])
    else
      render_validation_error(Array.new.push("Idは必須です")) and return
    end

    if staff.authenticate(params[:password])
      # セッションキー発行
      staff.session_key = SecureRandom.hex
      staff.save
      render_login_staff(staff)
    else
      render_validation_error(Array.new.push("Passwordが間違っています"))
    end
  end

  # ------------------------------
  # [AL-2] 管理画面ログアウト
  # PUT /admin/staff/logout
  # ------------------------------
  def logout
    unless params[:id].blank?
      staff = Staff.find_by!(id: params[:id])
    else
      render_validation_error(Array.new.push("Idは必須です")) and return
    end

    staff.session_key = :null
    staff.save

    render_success(:staff, "ログアウト", staff.id)
  end
end

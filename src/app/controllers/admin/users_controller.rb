# encoding: utf-8
# ------------------------------
# [管理用] ユーザーコントローラー
# ------------------------------
class Admin::UsersController < Admin::ApplicationController
  include ValidateCondition
  include RenderUsersResponse

  # ------------------------------
  # [AU-1] ユーザー一覧取得・検索
  # GET /admin/users
  # ------------------------------
  def index
    # TODO 絞り込み
    users = User.all

    users_result = users
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    render_user_list_admin(users_result, users.count)
  end

  # ------------------------------
  # [AU-2] ユーザー詳細取得
  # GET /admin/users/:id
  # ------------------------------
  def show
    user = User.find_by!(id: params[:id])

    spots_count = 0
    plans_result = Plan.where(user_id: user.id)
    plans_result.each do |plan|
      spots_count += Spot.where(plan_id: plan.id).count
    end

    counts = {
      spots_count: spots_count,
      monthly_count: Log.where("created_at > ? and user_id = ?", Date.today - 1.months, user.id).count,
      plan_count: Plan.where(user_id: user.id).count,
      favored_plan_count: Favorite.where(user_id: user.id).count,
      follow_count: Follow.where(user_id: user.id).count,
      follower_count: Follow.where(follow_user_id: user.id).count,
    }

    render_user_detail_admin(user, counts)
  end

  # ------------------------------
  # [AU-3] ユーザー属性編集
  # PUT /admin/users/:id/attribute
  # ------------------------------
  def update_attribute
    user = User.find_by!(id: params[:user_id])

    # ユーザー属性のバリデーション
    new_attribute = params[:user_attr]
    if new_attribute.nil?
      render_validation_error(Array.new.push("User attrは必須です")) and return
    end
    if user.user_attr == new_attribute
      render_validation_error(Array.new.push("User attrは既に" + new_attribute + "です")) and return
    end

    user.user_attr = new_attribute

    if user.save
      render_success(:user, :update, user.id)
    else
      render_validation_error(user.errors.full_messages)
    end
  end
end

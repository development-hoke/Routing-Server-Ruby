# encoding: utf-8
# ------------------------------
# いいねコントローラー
# ------------------------------
class Public::LikesController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include RenderPlansResponse
  include RenderUsersResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [L-1] ユーザーがいいねしたプラン一覧取得
  # GET /users/:user_id/likes
  # ------------------------------
  def index
    user = User.find_by!(id: params[:user_id])
    likes = Like.where(user_id: user.id)

    likes_result_ids = likes
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))
      .map(&:plan_id)

    liked_plans = Plan.find(likes_result_ids)

    additional_items_map = Hash.new
    liked_plans.each do |plan|
      # デートプラン作成者の情報取得
      user = User.find(plan.user_id)

      # デートプランに含まれるスポット情報の取得
      routes = Route.where(plan_id: plan.id).order(:order)
      spot_list = Array.new
      routes.each do |route|
        spot = Spot.find_by(id: route.spot_id)
        spot_list.push({
          order: route.order,
          spot_name: spot.name,
          latitude: spot.latitude,
          longitude: spot.longitude,
          place_id: spot.place_id || "",
          icon_url: spot.icon_url || "",
        })
      end

      additional_items = {
        user_id: user.id,
        user_name: user.name,
        user_attr: user.user_attr,
        spots: spot_list,
        like_count: Like.where(plan_id: plan.id).count,
        comment_count: Comment.where(plan_id: plan.id).count,
      }
      additional_items_map.store(plan.id, additional_items)
    end

    render_plan_list(liked_plans, additional_items_map, likes.count)
  end

  # ------------------------------
  # [L-2] プランのいいね登録
  # POST /plans/:plan_id/likes
  # ------------------------------
  def create
    plan = Plan.find_by!(id: params[:plan_id])
    user = User.find_by!(id: params[:user_id])

    if Like.find_by(plan_id: plan.id, user_id: user.id).present?
      render_validation_error(Array.new.push("いいね済みのデートプランです")) and return
    end

    if plan.user_id == user.id
      render_validation_error(Array.new.push("ユーザー自身のデートプランです")) and return
    end

    Like.create(plan_id: plan.id, user_id: user.id)

    # いいね通知
    if Setting.find_by(user_id: plan.user_id, notification_like: true).present?
      Notification.create(
        category: "like",
        user_id: user.id,
        plan_id: plan.id,
        target_user_id: plan.user_id,
      )
    end

    render_success(:like, :create, plan.id)
  end

  # ------------------------------
  # [L-3] プランのいいね解除
  # DELETE /plans/:plan_id/likes
  # ------------------------------
  def destroy
    plan = Plan.find_by!(id: params[:plan_id])
    user = User.find_by!(id: params[:user_id])
    like = Like.find_by(plan_id: plan.id, user_id: user.id)

    if like.present?
      like.destroy
      render_success(:like, :delete, plan.id)
    else
      render_validation_error(Array.new.push("いいねしていないデートプランです"))
    end
  end

  # ------------------------------
  # [L-4] プランにいいねしたユーザー一覧取得
  # GET /plans/:plan_id/likes
  # ------------------------------
  def index_users
    plan = Plan.find_by!(id: params[:plan_id])
    likes = Like.where(plan_id: plan.id)

    likes_result = likes
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    # ユーザー情報の取得
    users = User.find(likes_result.map(&:user_id))

    render_liked_user_list(users, likes.count)
  end
end

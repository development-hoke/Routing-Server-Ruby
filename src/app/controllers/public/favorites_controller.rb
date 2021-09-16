# encoding: utf-8
# ------------------------------
# お気に入りコントローラー
# ------------------------------
class Public::FavoritesController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include RenderPlansResponse
  include RenderUsersResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }


  # ------------------------------
  # [L-1] ユーザーがお気に入り登録したプラン一覧取得
  # GET /users/:user_id/favorites
  # ------------------------------
  def index
    user = User.find_by!(id: params[:user_id])
    favorites = Favorite.where(user_id: user.id)

    favorites_result_ids = favorites
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))
      .map(&:plan_id)

    favored_plans = Plan.find(favorites_result_ids)

    additional_items_map = Hash.new
    favored_plans.each do |plan|
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
        favorite_count: Favorite.where(plan_id: plan.id).count,
        comment_count: Comment.where(plan_id: plan.id).count,
      }
      additional_items_map.store(plan.id, additional_items)
    end

    render_plan_list(favored_plans, additional_items_map, favorites.count)
  end

  # ------------------------------
  # [L-2] プランのお気に入り登録
  # POST /plans/:plan_id/favorites
  # ------------------------------
  def create
    plan = Plan.find_by!(id: params[:plan_id])
    user = User.find_by!(id: params[:user_id])

    if Favorite.find_by(plan_id: plan.id, user_id: user.id).present?
      render_validation_error(Array.new.push("お気に入り登録済みのデートプランです")) and return
    end

    if plan.user_id == user.id
      render_validation_error(Array.new.push("ユーザー自身のデートプランです")) and return
    end

    Favorite.create(plan_id: plan.id, user_id: user.id)
    render_success(:favorite, :create, plan.id)
  end

  # ------------------------------
  # [L-3] プランのお気に入り解除
  # DELETE /plans/:plan_id/favorites
  # ------------------------------
  def destroy
    plan = Plan.find_by!(id: params[:plan_id])
    user = User.find_by!(id: params[:user_id])
    favorite = Favorite.find_by(plan_id: plan.id, user_id: user.id)

    if favorite.present?
      favorite.destroy
      render_success(:favorite, :delete, plan.id)
    else
      render_validation_error(Array.new.push("お気に入り登録していないデートプランです"))
    end
  end

  # ------------------------------
  # [L-4] プランをお気に入り登録したユーザー一覧取得
  # GET /plans/:plan_id/favorites
  # ------------------------------
  def index_users
    plan = Plan.find_by!(id: params[:plan_id])
    favorites = Favorite.where(plan_id: plan.id)

    favorites_result = favorites
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    # ユーザー情報の取得
    users = User.find(favorites_result.map(&:user_id))

    render_favored_user_list(users, favorites.count)
  end
end

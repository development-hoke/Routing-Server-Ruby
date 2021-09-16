# encoding: utf-8
# ------------------------------
# [管理用] デートプランコントローラー
# ------------------------------
class Admin::PlansController < Admin::ApplicationController
  include ValidateCondition
  include RenderPlansResponse

  # ------------------------------
  # [AP-1] デートプラン一覧取得・検索
  # GET /admin/plans
  # ------------------------------
  def index
    # TODO 絞り込み
    plans = Plan.all

    plans_result = plans
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    additional_items_map = Hash.new
    plans_result.each do |plan|
      user = User.find(plan.user_id)

      additional_items = {
        user_id: user.id,
        user_name: user.name,
        like_count: Like.where(plan_id: plan.id).count,
        comment_count: Comment.where(plan_id: plan.id).count,
      }
      additional_items_map.store(plan.id, additional_items)
    end

    render_plan_list_admin(plans_result, additional_items_map, plans.count)
  end

  # ------------------------------
  # [AP-2] デートプラン詳細取得
  # GET /admin/plans/:id
  # ------------------------------
  def show
    plan = Plan.find_by!(id: params[:id])

    # デートプランに含まれるデートスポットの取得
    routes = Route.where(plan_id: plan.id).order(:order)
    spot_list = Array.new
    routes.each do |route|
      spot = Spot.find_by(id: route.spot_id)
      spot_images = Image.where(spot_id: spot.id).pluck(:image_url)

      spot_list.push({
        order: route.order,
        need_time: route.need_time ||= 0,
        spot_id: spot.id,
        spot_name: spot.name,
        description: spot.description || "",
        latitude: spot.latitude,
        longitude: spot.longitude,
        images: spot_images,
        category: spot.category || "",
        opening_hours: spot.opening_hours || "",
        tel: spot.tel || "",
        site_url: spot.site_url || "",
        place_id: spot.place_id || "",
        icon_url: spot.icon_url || "",
      })
    end

    user = User.find(plan.user_id)
    additional_items = {
      spots: spot_list,
      user_id: user.id,
      user_name: user.name,
      like_count: Like.where(plan_id: plan.id).count,
      comment_count: Comment.where(plan_id: plan.id).count,
    }

    render_plan_detail_admin(plan, additional_items)
  end
end

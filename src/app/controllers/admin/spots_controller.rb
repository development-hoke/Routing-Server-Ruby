class Admin::SpotsController < Admin::ApplicationController
  include ValidateCondition
  include RenderSpotsResponse

  # ------------------------------
  # [AU-1] デートスポット一覧取得・検索
  # GET /admin/spots
  # ------------------------------
  def index
    spots = Spot.all

    spots_result = spots
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))
    images_map = Hash.new
    spots_result.each do |spot|
      spot_images = Image.where(spot_id: spot.id).pluck(:image_url)
      images_map.store(spot.id, spot_images)
    end

    render_spots_list_admin(spots_result, images_map, spots.count)
  end

  # ------------------------------
  # [AU-2] デートスポット詳細取得
  # GET /admin/spots/:id
  # ------------------------------
  def show
    spot = Spot.find_by!(id: params[:id])

    images_map = Hash.new
    user_data_map = Hash.new

    spot_image = Image.where(spot_id: spot.id).pluck(:image_url)
    images_map.store(spot.id, spot_image)

    if spot.plan_id.present?
      user_id = Plan.where(id: spot.plan_id).pluck(:user_id)
      user = User.find_by!(id: user_id)
      user_name = user.name
      user_data_map.store(spot.id, user_name)
    else
      user_data_map.store(spot.id, "")
    end

    counts = {
      image_count: Image.where(spot_id: spot.id).count,
      order_count: Route.where(spot_id: spot.id).count,
    }

    render_spot_detail_admin(spot, images_map, user_data_map, counts)
  end
end

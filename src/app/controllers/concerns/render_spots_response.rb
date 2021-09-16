# encoding: utf-8
# ------------------------------
# スポット参照系APIレスポンス生成モジュール
# ------------------------------
module RenderSpotsResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # スポット一覧取得レスポンス
  # ------------------------------
  def render_spots_list(spots, images_map, total)
    spot_list = Array.new

    spots.each do |spot|
      spot_list.push({
        spot_id: spot.id,
        spot_type: spot.spot_type ||= "",
        spot_name: spot.name,
        formatted_address: spot.address ||= "",
        description: spot.description ||= "",
        latitude: spot.latitude,
        longitude: spot.longitude,
        images: images_map[spot.id],
        category: spot.category ||= "",
        opening_hours: spot.opening_hours ||= "",
        formatted_phone_number: spot.tel ||= "",
        website: spot.site_url ||= "",
        place_id: spot.place_id ||= "",
        icon_url: spot.icon_url ||= "",
        updated_at: spot.updated_at,
        create_date: spot.created_at,
      })
    end

    render json: { total: total, spot_list: spot_list }
  end

  # ------------------------------
  # [管理画面] スポット一覧取得レスポンス
  # ------------------------------

  def render_spots_list_admin(spots, images_map, total)
    spot_list = Array.new

    spots.each do |spot|
      spot_list.push({
        spot_id: spot.id,
        spot_type: spot.spot_type,
        spot_name: spot.name,
        description: spot.description ||= "",
        latitude: spot.latitude,
        longitude: spot.longitude,
        image_url: images_map[spot.id],
        category: spot.category ||= "",
        business_time: spot.opening_hours ||= "",
        tel: spot.tel ||= "",
        website: spot.site_url ||= "",
        place_id: spot.place_id ||= "",
        icon_url: spot.icon_url ||= "",
        create_date: spot.created_at,
      })
    end

    render json: { total: total, spot_list: spot_list }
  end

  # ------------------------------
  # [管理画面] スポット詳細取得レスポンス
  # ------------------------------
  def render_spot_detail_admin(spot, images_map, user_data_map, counts)
    render json: {
      spot_id: spot.id,
      spot_type: spot.spot_type,
      spot_name: spot.name,
      description: spot.description ||= "",
      latitude: spot.latitude,
      longitude: spot.longitude,
      image_url: images_map[spot.id],
      category: spot.category ||= "",
      business_time: spot.opening_hours ||= "",
      tel: spot.tel ||= "",
      website: spot.site_url ||= "",
      place_id: spot.place_id ||= "",
      icon_url: spot.icon_url ||= "",
      create_date: spot.created_at,
      update_date: spot.updated_at,
      order_count: counts[:order_count],
      user_name: user_data_map[spot.id],
      image_count: counts[:image_count],

    }
  end
end

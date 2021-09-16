# encoding: utf-8
# ------------------------------
# スポットコントローラー
# ------------------------------
class Public::SpotsController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include RenderSpotsResponse

  prepend_before_action -> {
                          jwt_authenticate(request.headers["Authorization"])
                        }

  # ------------------------------
  # [S-1] スポット作成
  # POST /spots
  # ------------------------------
  def create
    spot = Spot.new(
      name: spot_params[:name],
      description: spot_params[:description],
      address: spot_params[:formatted_address],
      latitude: spot_params[:latitude],
      longitude: spot_params[:longitude],
      category: spot_params[:category],
      opening_hours: spot_params[:opening_hours],
      tel: spot_params[:formatted_phone_number],
      site_url: spot_params[:website],
      place_id: spot_params[:place_id],
      icon_url: spot_params[:icon_url],
      spot_type: spot_params[:spot_type],
    )

    if spot.save
      # スポット画像の登録
      unless params["images"].blank?
        params["images"].each do |image|
          if image.kind_of?(String)
            # URLの時
            image_url = image
          elsif image.kind_of?(Object)
            # Fileの時
            uploader = SpotImageUploader.new
            uploader.set_store_id(spot.id)
            uploader.store_dir
            uploader.store!(image)
            image_url = root_url.chop + uploader.url
          end

          # 保存
          Image.create!(
            spot_id: spot.id,
            image_url: image_url,
          )
        end
      end

      render_success(:spot, :create, spot.id)
    else
      render_validation_error(spot.errors.full_messages)
    end
  end

  # ------------------------------
  # [S-2] スポット検索
  # GET /spots/search
  # ------------------------------
  def search

    # 経度緯度での検索 AND/OR キーワード検索
    query_ll = "spots.latitude BETWEEN :min_lat AND :max_lat
                AND spots.longitude BETWEEN :min_long AND :max_long"

    query_keyword = "name LIKE :like_value 
                    OR description LIKE :like_value 
                    OR category LIKE :like_value"

    query_type = "spots.spot_type = :spot_type"

    if params[:latitude].present? && params[:longitude].present?
      # 半径5000メートル以内
      range = calc_lat_long(params[:latitude].to_d, params[:longitude].to_d, params[:radius] ? params[:radius].to_d : 5000.0)

      if params[:keyword].present?
        spots = Spot.all
                    .where("#{query_ll} AND #{query_keyword}",
                           min_lat: range[:min_lat],
                           max_lat: range[:max_lat],
                           min_long: range[:min_long],
                           max_long: range[:max_long],
                           like_value: "%#{params[:keyword]}%")
      else
        spots = Spot.where(
          "#{query_ll}",
          min_lat: range[:min_lat],
          max_lat: range[:max_lat],
          min_long: range[:min_long],
          max_long: range[:max_long],
        )
      end
    elsif params[:keyword].present?
      spots = Spot.where(
        "#{query_keyword}",
        like_value: "%#{params[:keyword]}%",
      )
    else
      render_validation_error(Array.new.push("KeywordまたはLatitude/Longtitudeのいずれかは必須です")) and return
    end

    if params[:spot_type].present?
      spots = spots.where("#{query_type}", spot_type: params[:spot_type])
    end

    spots_result = spots
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    # 各スポット画像の取得
    images_map = Hash.new
    spots_result.each do |spot|
      spot_images = Image.where(spot_id: spot.id).pluck(:image_url)
      images_map.store(spot.id, spot_images)
    end

    render_spots_list(spots_result, images_map, spots.count)
  end

  def calc_lat_long(lat, long, rad)
    # 経度緯度計算の前提
    #
    # １ 地球は平面である
    # ２ 緯度1度が111000メートル
    # ３ 経度1度が91000メートル
    max_lat = lat + rad / 111000
    min_lat = lat - rad / 111000
    max_long = long + rad / 91000
    min_long = long - rad / 91000

    return { max_lat: max_lat, min_lat: min_lat, max_long: max_long, min_long: min_long }
  end

  private

  def spot_params
    params
      .permit(
        :name,
        :description,
        :formatted_address,
        :latitude,
        :longitude,
        :category,
        :opening_hours,
        :formatted_phone_number,
        :website,
        :place_id,
        :icon_url,
        :spot_type,
        images: [],
      )
  end
end

# encoding: utf-8
# ------------------------------
# デートプランコントローラー
# ------------------------------
class Public::PlansController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include ValidateOnController
  include RenderPlansResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [P-1] デートプラン一覧取得
  # GET /plans
  # ------------------------------
  def index
    if params[:user_id].nil?
      plans = Plan.all
    else
      plans = Plan.where(user_id: params[:user_id])
    end

    plans_result = plans
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    additional_items_map = Hash.new
    plans_result.each do |plan|
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

    render_plan_list(plans_result, additional_items_map, plans.count)
  end

  # ------------------------------
  # [P-2] デートプラン作成
  # POST /plans
  # ------------------------------
  def create
    User.find_by!(id: plan_params[:user_id])

    # spotsパラメータのバリデーション
    results_validate_spots = validate_spots_params(plan_params[:spots])
    unless results_validate_spots.empty?
      render_validation_error(results_validate_spots) and return
    end

    plan = Plan.new(
      user_id: plan_params[:user_id],
      title: plan_params[:title],
      description: plan_params[:description],
      date: plan_params[:date],
      transportation: plan_params[:transportation].to_s,
      need_time: plan_params[:need_time],
      datetime_status: plan_params[:datetime_status],
      status: plan_params[:status],
    )

    if plan.save
      plan_params[:spots].each do |spot_params|
        # スポットIDがある場合,当該スポットをルート紐付け
        unless spot_params[:spot_id].nil?
          # 存在しないスポットIDであればスルー
          exist_spot = Spot.find_by(id: spot_params[:spot_id])
          if exist_spot.nil?
            next
          end

          # プランとスポットの紐付け
          Route.create!(
            plan_id: plan.id,
            spot_id: exist_spot.id,
            order: spot_params[:order],
            need_time: spot_params[:need_time],
          )

          next
        end

        # スポットIDがない場合,送信された情報でスポットを新規登録してルート紐付け
        spot = Spot.create!(
          name: spot_params[:spot_name],
          description: spot_params[:description],
          latitude: spot_params[:latitude],
          longitude: spot_params[:longitude],
          category: spot_params[:category],
          opening_hours: spot_params[:opening_hours],
          tel: spot_params[:tel],
          site_url: spot_params[:site_url],
          place_id: spot_params[:place_id],
          icon_url: spot_params[:icon_url],
          spot_type: spot_params[:spot_type],
        )

        # スポット画像の登録
        if spot_params[:images].present?
          spot_params[:images].each do |image_url|
            Image.create!(
              spot_id: spot.id,
              image_url: image_url,
            )
          end
        end

        # プランとスポットの紐付け
        Route.create!(
          plan_id: plan.id,
          spot_id: spot.id,
          order: spot_params[:order],
          need_time: spot_params[:need_time],
        )
      end

      render_success(:plan, :create, plan.id)
    else
      render_validation_error(plan.errors.full_messages)
    end
  end

  # ------------------------------
  # [P-3] デートプラン詳細取得
  # GET /plans/:id
  # ------------------------------
  def show
    plan = Plan.find_by!(id: params[:id])

    # 自分がプランをいいねしているか,作成者をフォローしているか
    if params[:user_id].nil?
      render_validation_error(Array.new.push("User Idは必須です")) and return
    else
      user = User.find_by!(id: params[:user_id])
      is_liked = Like.find_by(plan_id: plan.id, user_id: user.id).present?
      is_follow = Follow.find_by(user_id: user.id, follow_user_id: plan.user_id).present?
    end

    # デートプランに含まれるスポット情報の取得
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

    # デートプラン作成者の情報取得
    user = User.find(plan.user_id)
    additional_items = {
      spots: spot_list,
      user_id: user.id,
      user_name: user.name,
      user_attr: user.user_attr,
      like_count: Like.where(plan_id: plan.id).count,
      comment_count: Comment.where(plan_id: plan.id).count,
      is_liked: is_liked,
      is_follow: is_follow,
    }

    render_plan_detail(plan, additional_items)
  end

  # ------------------------------
  # [P-4] デートプラン編集
  # PUT /plans/:id
  # ------------------------------
  def update
    plan = Plan.find_by!(id: params[:id])
    if plan_params[:user_id] != plan.user_id
      render_validation_error(Array.new.push("デートプラン作成者のUser Idを入力してください")) and return
    end

    # spotsパラメータのバリデーション
    results_validate_spots = validate_spots_params(plan_params[:spots])
    unless results_validate_spots.empty?
      render_validation_error(results_validate_spots) and return
    end

    # デートプラン更新
    if plan.update(
      title: plan_params[:title],
      description: plan_params[:description],
      date: plan_params[:date],
      transportation: plan_params[:transportation].to_s,
      need_time: plan_params[:need_time],
    )
      # デートスポットの紐付け全件削除
      Route.where(plan_id: plan.id).destroy_all

      # デートスポット新規登録
      plan_params[:spots].each do |spot_params|
        # スポットIDがある場合,当該スポットをルート紐付け
        unless spot_params[:spot_id].nil?
          # 存在しないスポットIDであればスルー
          exist_spot = Spot.find_by(id: spot_params[:spot_id])
          if exist_spot.nil?
            next
          end

          # プランとスポットの紐付け
          Route.create!(
            plan_id: plan.id,
            spot_id: spot_params[:spot_id],
            order: spot_params[:order],
            need_time: spot_params[:need_time],
          )

          next
        end

        # スポットIDがない場合,送信された情報でスポットを新規登録してルート紐付け
        spot = Spot.create!(
          name: spot_params[:spot_name],
          description: spot_params[:description],
          latitude: spot_params[:latitude],
          longitude: spot_params[:longitude],
          category: spot_params[:category],
          opening_hours: spot_params[:opening_hours],
          tel: spot_params[:tel],
          site_url: spot_params[:site_url],
          place_id: spot_params[:place_id],
          icon_url: spot_params[:icon_url],
        )

        # スポット画像の登録
        if spot_params[:images].present?
          spot_params[:images].each do |image_url|
            Image.create!(
              spot_id: spot.id,
              image_url: image_url,
            )
          end
        end

        # プランとスポットの紐付け
        Route.create!(
          plan_id: plan.id,
          spot_id: spot.id,
          order: spot_params[:order],
          need_time: spot_params[:need_time],
        )
      end

      render_success(:plan, :update, plan.id)
    else
      render_validation_error(plan.errors.full_messages)
    end
  end

  # ------------------------------
  # [P-5] デートプラン削除
  # DELETE /plans/:id
  # ------------------------------
  def destroy
    plan = Plan.find_by!(id: params[:id])
    Route.where(plan_id: plan.id).destroy_all
    plan.destroy

    render_success(:plan, :delete, plan.id)
  end

  # ------------------------------
  # [P-6] デートプラン検索
  # GET /plans/search
  # ------------------------------
  def search
    unless params[:keyword].blank?
      plans = Plan.where(
        "title LIKE :like_value OR description LIKE :like_value",
        like_value: "%#{params[:keyword]}%",
      )
    else
      render_validation_error(Array.new.push("Keywordは必須です")) and return
    end

    unless params[:user_id].blank?
      User.find_by!(id: params[:user_id])
    else
      render_validation_error(Array.new.push("User Idは必須です")) and return
    end

    history = History.find_by(word: params[:keyword])
    unless history.nil?
      history.destroy
    end

    History.create(word: params[:keyword], user_id: params[:user_id])

    plans_result = plans
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    additional_items_map = Hash.new
    plans_result.each do |plan|
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

    render_plan_list(plans_result, additional_items_map, plans.count)
  end

  # ------------------------------
  # [P-7] デートプラン公開・非公開
  # PUT /plans/:id/status
  # ------------------------------
  def update_status
    plan = Plan.find_by!(id: params[:plan_id])
    if params[:user_id] != plan.user_id
      render_validation_error(Array.new.push("デートプラン作成者のUser Idを入力してください")) and return
    end

    # デートプランプランステータスのバリデーション
    new_status = params[:status]
    if new_status.nil?
      render_validation_error(Array.new.push("Statusは必須です")) and return
    end
    unless new_status == "public" || new_status == "private"
      render_validation_error(Array.new.push("Statusはpublic/privateを入力してください")) and return
    end
    if plan.status == new_status
      render_validation_error(Array.new.push("Statusは既に" + new_status + "です")) and return
    end

    plan.status = new_status

    if plan.save
      render_success(:plan, :update, plan.id)
    else
      render_validation_error(plan.errors.full_messages)
    end
  end

  # ------------------------------
  # [P-8] デートプラン日時公開・非公開
  # PUT /plans/:id/datetime_status
  # ------------------------------
  def update_datetime_status
    plan = Plan.find_by!(id: params[:plan_id])
    if params[:user_id] != plan.user_id
      render_validation_error(Array.new.push("デートプラン作成者のUser Idを入力してください")) and return
    end

    # デートプランプランステータスのバリデーション
    new_status = params[:datetime_status]
    if new_status.nil?
      render_validation_error(Array.new.push("Statusは必須です")) and return
    end
    unless new_status == "public" || new_status == "private"
      render_validation_error(Array.new.push("Statusはpublic/privateを入力してください")) and return
    end
    if plan.status == new_status
      render_validation_error(Array.new.push("Statusは既に" + new_status + "です")) and return
    end

    plan.datetime_status = new_status

    if plan.save
      render_success(:plan, :update, plan.id)
    else
      render_validation_error(plan.errors.full_messages)
    end
  end

  private

  # デートプラン作成/編集リクエストパラメータ
  def plan_params
    params
      .permit(
        :user_id, :title, :description, :date, :need_time, :status, :datetime_status,
        transportation: [],
        spots: [
          :order,
          :need_time,
          :spot_id,
          :spot_name,
          :spot_type,
          :description,
          :latitude,
          :longitude,
          :category,
          :opening_hours,
          :tel,
          :site_url,
          :place_id,
          :icon_url,
          images: [],
        ],
      )
  end
end

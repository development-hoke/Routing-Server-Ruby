# encoding: utf-8
# ------------------------------
# デートプラン参照系APIレスポンス生成モジュール
# ------------------------------
module RenderPlansResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # デートプラン一覧取得レスポンス
  # ------------------------------
  def render_plan_list(plans, additional_items_map, total)
    plan_list = Array.new

    plans.each do |p|
      additional_items = additional_items_map[p.id]

      plan = {
        plan_id: p.id,
        title: p.title,
        description: p.description ||= "",
        need_time: p.need_time,
        status: p.status,
        datetime_status: p.datetime_status,
        spots: additional_items[:spots],
        user_id: additional_items[:user_id],
        user_name: additional_items[:user_name],
        user_attr: additional_items[:user_attr],
        user_image_url: "/icons/" + additional_items[:user_id] + ".jpg",
        like_count: additional_items[:like_count],
        comment_count: additional_items[:comment_count],
        create_date: p.created_at,
      }

      plan_list.push(plan)
    end

    render json: { total: total, plan_list: plan_list }
  end

  # ------------------------------
  # [管理画面] デートプラン一覧取得・検索レスポンス
  # ------------------------------
  def render_plan_list_admin(plans, additional_items_map, total)
    plan_list = Array.new

    plans.each do |p|
      additional_items = additional_items_map[p.id]

      plan = {
        plan_id: p.id,
        title: p.title,
        status: p.status,
        datetime_status: p.datetime_status,
        user_id: additional_items[:user_id],
        user_name: additional_items[:user_name],
        like_count: additional_items[:like_count],
        comment_count: additional_items[:comment_count],
        create_date: p.created_at,
      }

      plan_list.push(plan)
    end

    render json: { total: total, plan_list: plan_list }
  end

  # ------------------------------
  # デートプラン詳細取得レスポンス
  # ------------------------------
  def render_plan_detail(plan, additional_items)
    if plan.transportation.nil?
      transportation = []
    else
      transportation = plan.transportation.slice(2..-3).delete(", ").split("\"\"")
    end

    render json: {
      plan_id: plan.id,
      title: plan.title,
      description: plan.description ||= "",
      date: plan.date ||= "",
      transportation: transportation,
      need_time: plan.need_time ||= "",
      status: plan.status,
      datetime_status: plan.datetime_status,
      spots: additional_items[:spots],
      user_id: additional_items[:user_id],
      user_name: additional_items[:user_name],
      user_attr: additional_items[:user_attr],
      user_image_url: "/icons/" + additional_items[:user_id] + ".jpg",
      like_count: additional_items[:like_count],
      comment_count: additional_items[:comment_count],
      is_liked: additional_items[:is_liked],
      is_follow: additional_items[:is_follow],
      create_date: plan.created_at,
    }
  end

  # ------------------------------
  # [管理画面] デートプラン詳細取得レスポンス
  # ------------------------------
  def render_plan_detail_admin(plan, additional_items)
    if plan.transportation.nil?
      transportation = []
    else
      transportation = plan.transportation.slice(2..-3).delete(", ").split("\"\"")
    end

    render json: {
      plan_id: plan.id,
      title: plan.title,
      description: plan.description ||= "",
      date: plan.date ||= "",
      transportation: transportation,
      need_time: plan.need_time ||= "",
      status: plan.status,
      datetime_status: plan.datetime_status,
      spots: additional_items[:spots],
      user_id: additional_items[:user_id],
      user_name: additional_items[:user_name],
      like_count: additional_items[:like_count],
      comment_count: additional_items[:comment_count],
      create_date: plan.created_at,
      update_date: plan.updated_at,
    }
  end
end

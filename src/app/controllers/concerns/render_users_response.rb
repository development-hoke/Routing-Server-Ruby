# encoding: utf-8
# ------------------------------
# ユーザー参照系APIレスポンス生成モジュール
# ------------------------------
module RenderUsersResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # [管理画面] ユーザー一覧取得・検索レスポンス
  # ------------------------------
  def render_user_list_admin(users, total)
    user_list = Array.new

    users.each do |u|
      user = {
        user_id: u.id,
        name: u.name,
        sex: u.sex,
        age: u.age,
        mail_address: u.mail_address,
        user_attr: u.user_attr,
        status: u.status,
        image_url: u.image_url,
        register_date: u.created_at,
      }

      user_list.push(user)
    end

    render json: { total: total, user_list: user_list }
  end

  # ------------------------------
  # ユーザー情報取得レスポンス
  # ------------------------------
  def render_user_detail(user, counts, is_follow)
    render json: {
      user_id: user.id,
      name: user.name,
      onedate_id: user.onedate_id ||= "",
      profile: user.profile ||= "",
      sex: user.sex,
      age: user.age,
      area: user.area,
      address: user.address ||= "",
      mail_address: user.mail_address,
      user_attr: user.user_attr,
      status: user.status,
      image_url: user.image_url,
      plan_count: counts[:plan_count],
      favored_plan_count: counts[:favored_plan_count],
      follow_count: counts[:follow_count],
      follower_count: counts[:follower_count],
      is_follow: is_follow,
    }
  end

  # ------------------------------
  # [管理画面] ユーザー詳細取得レスポンス
  # ------------------------------
  def render_user_detail_admin(user, counts)
    render json: {
      user_id: user.id,
      name: user.name,
      onedate_id: user.onedate_id ||= "",
      profile: user.profile ||= "",
      sex: user.sex,
      age: user.age,
      area: user.area,
      address: user.address ||= "",
      mail_address: user.mail_address,
      user_attr: user.user_attr,
      status: user.status,
      image_url: user.image_url,
      spots_count: counts[:spots_count],
      monthly_count: counts[:monthly_count],
      plan_count: counts[:plan_count],
      favored_plan_count: counts[:favored_plan_count],
      follow_count: counts[:follow_count],
      follower_count: counts[:follower_count],
      register_date: user.created_at,
      update_date: user.updated_at,
      login_count: user.login_num,
    }
  end

  # ------------------------------
  # アプリにログインレスポンス
  # ------------------------------
  def render_login_user(user)
    render json: {
      user_id: user.id,
      name: user.name,
      image_url: user.image_url,
    }
  end

  # ------------------------------
  # アプリに登録レスポンス
  # ------------------------------
  def render_signup_user(user)
    render json: {
      user_id: user.id,
      name: user.name,
      image_url: user.image_url,
    }
  end

  # ------------------------------
  # プランにいいねしたユーザー一覧取得レスポンス
  # ------------------------------
  def render_liked_user_list(users, total)
    liked_user_list = users.map { |user|
      {
        user_id: user.id,
        user_name: user.name,
        user_attr: user.user_attr,
        image_url: user.image_url,
      }
    }

    render json: { total: total, liked_user_list: liked_user_list }
  end

  # ------------------------------
  # プランをお気に入り登録したユーザー一覧取得レスポンス
  # ------------------------------
  def render_favored_user_list(users, total)
    liked_user_list = users.map { |user|
      {
        user_id: user.id,
        user_name: user.name,
        user_attr: user.user_attr,
        image_url: user.image_url,
      }
    }

    render json: { total: total, favored_user_list: liked_user_list }
  end

  # ------------------------------
  # フォローリスト取得レスポンス
  # ------------------------------
  def render_follow_list(users, additional_items_map, total)
    follow_list = Array.new

    users.each do |u|
      additional_item = additional_items_map[u.id]
      follow_list.push(
        {
          user_id: u.id,
          user_name: u.name,
          user_attr: u.user_attr,
          image_url: u.image_url,
          plan_count: additional_item[:plan_count],
          follow_date: additional_item[:follow_date],
          is_followed: additional_item[:is_followed],
        }
      )
    end

    render json: { total: total, follow_list: follow_list }
  end

  # ------------------------------
  # フォロワーリスト取得レスポンス
  # ------------------------------
  def render_follower_list(users, additional_items_map, total)
    follower_list = Array.new

    users.each do |u|
      additional_item = additional_items_map[u.id]
      follower_list.push(
        {
          user_id: u.id,
          user_name: u.name,
          user_attr: u.user_attr,
          image_url: u.image_url,
          plan_count: additional_item[:plan_count],
          followed_date: additional_item[:followed_date],
          is_follow: additional_item[:is_follow],
        }
      )
    end

    render json: { total: total, follower_list: follower_list }
  end
end

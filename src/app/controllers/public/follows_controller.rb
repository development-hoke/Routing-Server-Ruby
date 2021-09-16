# encoding: utf-8
# ------------------------------
# アカウントフォローコントローラー
# ------------------------------
class Public::FollowsController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include RenderUsersResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [F-1] フォローリスト取得
  # GET /users/:user_id/follows
  # ------------------------------
  def index
    user = User.find_by!(id: params[:user_id])
    follows = Follow.where(user_id: user.id)

    follows_result = follows
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    # ユーザー情報の取得
    users = User.find(follows_result.map(&:follow_user_id))

    # フォロー日時とデートプラン数の取得
    aditional_items_map = Hash.new
    users.each do |target_user|
      aditional_items_map.store(
        target_user.id,
        {
          plan_count: Plan.where(user_id: target_user.id).count,
          follow_date: follows_result.find_by(user_id: user.id, follow_user_id: target_user.id).created_at,
          is_followed: Follow.find_by(user_id: target_user.id, follow_user_id: user.id).present?,
        }
      )
    end

    render_follow_list(users, aditional_items_map, follows.count)
  end

  # ------------------------------
  # [F-2] フォロワーリスト取得
  # GET /users/:user_id/followers
  # ------------------------------
  def index_followers
    user = User.find_by!(id: params[:user_id])
    followers = Follow.where(follow_user_id: user.id)

    followers_result = followers
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    # ユーザー情報の取得
    users = User.find(followers_result.map(&:user_id))

    # フォロー日時とデートプラン数の取得
    aditional_items_map = Hash.new
    users.each do |target_user|
      aditional_items_map.store(
        target_user.id,
        {
          plan_count: Plan.where(user_id: target_user.id).count,
          followed_date: followers_result.find_by(user_id: target_user.id, follow_user_id: user.id).created_at,
          is_follow: Follow.find_by(user_id: user.id, follow_user_id: target_user.id).present?,
        }
      )
    end

    render_follower_list(users, aditional_items_map, followers.count)
  end

  # ------------------------------
  # [F-3] アカウントフォロー
  # POST /users/:follow_user_id/followers
  # ------------------------------
  def create
    user = User.find_by!(id: params[:user_id])
    follow_user = User.find_by!(id: params[:follow_user_id])

    if Follow.find_by(user_id: user.id, follow_user_id: follow_user.id).present?
      render_validation_error(Array.new.push("フォロー済みのユーザーです")) and return
    end

    if user.id == follow_user.id
      render_validation_error(Array.new.push("自分はフォローできません")) and return
    end

    Follow.create(user_id: user.id, follow_user_id: follow_user.id)

    # フォロー通知
    if Setting.find_by(user_id: follow_user.id, notification_follow: true).present?
      Notification.create(
        category: "follow",
        user_id: user.id,
        target_user_id: follow_user.id,
      )
    end

    render_success(:follow, :create, follow_user.id)
  end

  # ------------------------------
  # [F-4] アカウントフォロー解除
  # DELETE /users/:follow_user_id/followers
  # ------------------------------
  def destroy
    user = User.find_by!(id: params[:user_id])
    follow_user = User.find_by!(id: params[:follow_user_id])
    follow = Follow.find_by(user_id: user.id, follow_user_id: follow_user.id)

    if follow.present?
      follow.destroy
      render_success(:follow, :delete, follow_user.id)
    else
      render_validation_error(Array.new.push("フォローしていないユーザーです"))
    end
  end
end

# encoding: utf-8
# ------------------------------
# コメントコントローラー
# ------------------------------
class Public::CommentsController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include RenderCommentsResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [C-1] コメント一覧取得
  # GET /plans/:plan_id/comments
  # ------------------------------
  def index
    plan = Plan.find_by!(id: params[:plan_id])
    comments = Comment.where(plan_id: plan.id)

    comments_result = comments
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: validate_sort(params[:sort]))

    # ユーザー情報の取得
    additional_items_map = Hash.new
    comments_result.each do |comment|
      user = User.find(comment.user_id)
      additional_items = {
        user_id: user.id,
        user_name: user.name,
        user_attr: user.user_attr,
      }
      additional_items_map.store(comment.id, additional_items)
    end

    render_comment_list(comments_result, additional_items_map, comments.count)
  end

  # ------------------------------
  # [C-2] コメント投稿
  # POST /plans/:plan_id/comments
  # ------------------------------
  def create
    plan = Plan.find_by!(id: params[:plan_id])
    user = User.find_by!(id: plan_params[:user_id])
    comment = Comment.new(plan_id: plan.id, user_id: user.id, comment: plan_params[:comment])

    if comment.save
      # コメント通知
      if Setting.find_by(user_id: plan.user_id, notification_comment: true).present?
        Notification.create(
          category: "comment",
          user_id: user.id,
          comment_id: comment.id,
          plan_id: plan.id,
          target_user_id: plan.user_id,
        )
      end

      render_success(:comment, :create, plan.id)
    else
      render_validation_error(comment.errors.full_messages)
    end
  end

  # ------------------------------
  # [C-3] コメント削除
  # DELETE /plans/:plan_id/comments/:comment_id
  # ------------------------------
  def destroy
    comment = Comment.find_by!(id: params[:id], plan_id: params[:plan_id])
    user = User.find_by!(id: params[:user_id])

    if user.id != comment.user_id
      render_validation_error(Array.new.push("コメント投稿者のUser Idを入力してください")) and return
    end

    comment.destroy
    render_success(:comment, :delete, comment.id)
  end

  private

  # コメント投稿リクエストパラメータ
  def plan_params
    params.permit(:user_id, :comment)
  end
end

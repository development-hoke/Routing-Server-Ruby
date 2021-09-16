# encoding: utf-8
# ------------------------------
# 検索履歴コントローラー
# ------------------------------
class Public::HistoriesController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateCondition
  include ValidateOnController
  include RenderHistoriesResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [H-1] 検索履歴一覧取得
  # GET /plans/search/history
  # ------------------------------
  def index
    user = User.find_by!(id: params[:user_id])
    histories = History.where(user_id: user.id)

    histories_result = History
      .limit(validate_limit(params[:limit]))
      .offset(validate_offset(params[:offset]))
      .order(created_at: :desc)

    render_history_list(histories_result, histories.count)
  end

  # ------------------------------
  # [H-2] 検索履歴削除
  # DELETE /plans/search/history/:history_id
  # ------------------------------
  def destroy
    User.find_by!(id: params[:user_id])
    history = History.find_by!(id: params[:history_id])
    history.destroy

    render_success(:history, :delete, history.id)
  end
end

# encoding: utf-8
# ------------------------------
# 検索履歴取得系APIレスポンス生成モジュール
# ------------------------------
module RenderHistoriesResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # 検索履歴一覧取得レスポンス
  # ------------------------------
  def render_history_list(histories, total)
    history_list = Array.new

    histories.each do |h|
      history_list.push({
        history_id: h.id,
        word: h.word,
        search_date: h.created_at,
      })
    end

    render json: { total: total, history_list: history_list }
  end
end

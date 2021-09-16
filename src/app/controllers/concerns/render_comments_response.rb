# encoding: utf-8
# ------------------------------
# コメント参照系APIレスポンス生成モジュール
# ------------------------------
module RenderCommentsResponse
  extend ActiveSupport::Concern

  # ------------------------------
  # コメント一覧取得レスポンス
  # ------------------------------
  def render_comment_list(comments, additional_items_map, total)
    comment_list = Array.new

    comments.each do |c|
      additional_items = additional_items_map[c.id]

      comment = {
        comment_id: c.id,
        comment: c.comment,
        create_date: c.created_at,
        user_id: additional_items[:user_id],
        user_name: additional_items[:user_name],
        user_attr: additional_items[:user_attr],
        user_image_url: "/icons/" + additional_items[:user_id] + ".jpg",
      }

      comment_list.push(comment)
    end

    render json: { total: total, comment_list: comment_list }
  end
end

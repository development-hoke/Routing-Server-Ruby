# encoding: utf-8
# ------------------------------
# クエリパラメータ(検索条件)バリデーションモジュール
# ------------------------------
module ValidateCondition
  extend ActiveSupport::Concern

  # limit
  def validate_limit(value)
    limit = value =~ /^[0-9]+$/ ? params[:limit] : 20
  end

  # desc
  def validate_offset(value)
    offset = value =~ /^[0-9]+$/ ? params[:offset] : 0
  end

  # sort
  def validate_sort(value)
    sort = value == "asc" ? :asc : :desc
  end
end

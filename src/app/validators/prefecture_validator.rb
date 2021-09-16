# encoding: utf-8
# ------------------------------
# 都道府県バリデーター
# ------------------------------
class PrefectureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    prefectures = [
      "hokkaido", "aomori", "iwate", "miyagi", "akita", "yamagata", "fukushima",
      "ibaraki", "tochigi", "gunma", "saitama", "chiba", "tokyo", "kanagawa",
      "niigata", "toyama", "ishikawa", "fukui", "yamanashi", "nagano", "gifu",
      "shizuoka", "aichi", "mie", "shiga", "kyoto", "osaka", "hyogo",
      "nara", "wakayama", "tottori", "shimane", "okayama", "hiroshima", "yamaguchi",
      "tokushima", "kagawa", "ehime", "kochi", "fukuoka", "saga", "nagasaki",
      "kumamoto", "oita", "miyazaki", "kagoshima", "okinawa",
    ]

    unless prefectures.include?(value)
      record.errors[attribute] << (options[:message] || "は都道府県(ex: tokyo)を入力してください")
    end
  end
end

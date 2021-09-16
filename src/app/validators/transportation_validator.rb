# encoding: utf-8
# ------------------------------
# 交通手段バリデーター
# ------------------------------
class TransportationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    transportations = ["car", "train", "bus", "walk"]

    # 先頭の「["」と末尾の「"]」と間の「, 」を削除して「""」で分割
    target_list = value.slice(2..-3).delete(", ").split("\"\"")

    target_list.each do |target|
      unless transportations.include?(target)
        record.errors[attribute] << (options[:message] || "は交通手段(car/train/bus/walk)を入力してください")

        # 要素の1つでもfalseの時点で終了
        return
      end
    end
  end
end

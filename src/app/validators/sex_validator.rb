# encoding: utf-8
# ------------------------------
# 性別バリデーター
# ------------------------------
class SexValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value == "man" || value == "woman"
      record.errors[attribute] << (options[:message] || "はman/womanを入力してください")
    end
  end
end

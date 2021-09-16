# encoding: utf-8
# ------------------------------
# ユーザー属性バリデーター
# ------------------------------
class UserAttributeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value == "ordinary" || value == "official"
      record.errors[attribute] << (options[:message] || "はordinary/officialを入力してください")
    end
  end
end

# encoding: utf-8
# ------------------------------
# ユーザーステータスバリデーター
# ------------------------------
class UserStatusValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value == "public" || value == "private" || value == "canceled"
      record.errors[attribute] << (options[:message] || "はpublic/private/canceledを入力してください")
    end
  end
end

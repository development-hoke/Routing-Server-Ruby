# encoding: utf-8
# ------------------------------
# 半角英数バリデーター
# ------------------------------
class AlphaNumericValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-zA-Z0-9]+\z/
      record.errors[attribute] << (options[:message] || "は半角英数を入力してください")
    end
  end
end

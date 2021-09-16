# encoding: utf-8
# ------------------------------
# 日付バリデーター
# ------------------------------
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^\d{4}-\d{1,2}-\d{1,2}$/
      record.errors[attribute] << (options[:message] || "は日付(yyyy-MM-dd)を入力してください")
    end
  end
end

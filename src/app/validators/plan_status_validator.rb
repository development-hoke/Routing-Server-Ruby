# encoding: utf-8
# ------------------------------
# デートプランステータスバリデーター
# ------------------------------
class PlanStatusValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value == "public" || value == "private" || value == "deleted"
      record.errors[attribute] << (options[:message] || "はpublic/private/deletedを入力してください")
    end
  end
end

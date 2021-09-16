# encoding: utf-8
# ------------------------------
# 1DID
# ------------------------------
class OnedateIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-zA-Z0-9]+\z/
      record.errors[attribute] << (options[:message] || "IDは半角英数を入力してください")
    end
    unless value.length.between?(6, 20)
      record.errors[attribute] << (options[:message] || "IDは6文字以上20文字以下にしてください")
    end
  end
end
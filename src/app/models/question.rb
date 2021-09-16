# encoding: utf-8
# ------------------------------
# Question モデル
# ------------------------------
class Question < ApplicationRecord
  # バリデーション
  validates :question, presence: true, length: { minimum: 1, maximum: 500 }
end

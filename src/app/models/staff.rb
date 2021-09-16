# encoding: utf-8
# ------------------------------
# Staff モデル
# ------------------------------
class Staff < ApplicationRecord
  has_secure_password

  # バリデーション
  validates :id, presence: true, length: { minimum: 1, maximum: 8 }
end

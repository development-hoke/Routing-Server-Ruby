# encoding: utf-8
# ------------------------------
# Comment モデル
# ------------------------------
class Comment < ApplicationRecord
  # 32桁のランダムな文字列でIDを生成する
  before_create :set_hex_id

  # バリデーション
  validates :comment, presence: true, length: { minimum: 1, maximum: 100 }

  def set_hex_id
    self.id = SecureRandom.hex
  end
end

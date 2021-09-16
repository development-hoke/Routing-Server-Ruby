# encoding: utf-8
# ------------------------------
# Spot モデル
# @author kotatanaka, madan
# ------------------------------
class Spot < ApplicationRecord
  # 32桁のランダムな文字列でIDを生成する
  before_create :set_hex_id

  # バリデーション
  validates :name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  validates :spot_type, presence: true, length: { minimum: 1, maximum: 100 }

  def set_hex_id
    self.id = SecureRandom.hex
  end
end

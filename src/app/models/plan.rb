# encoding: utf-8
# ------------------------------
# Plan モデル
# ------------------------------
class Plan < ApplicationRecord
  # 32桁のランダムな文字列でIDを生成する
  before_create :set_hex_id

  # バリデーション
  validates :title, presence: true, length: { minimum: 1, maximum: 20 }
  validates :description, length: { maximum: 200 }
  validates :need_time, numericality: true
  validates :transportation, transportation: true
  validates :status, presence: true, plan_status: true
  validates :datetime_status, presence: true, plan_datetime_status: true

  def set_hex_id
    self.id = SecureRandom.hex
  end
end

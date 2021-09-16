# encoding: utf-8
# ------------------------------
# Route モデル
# ------------------------------
class Route < ApplicationRecord
  # バリデーション
  validates :order, presence: true, numericality: true
  validates :need_time, presence: true, numericality: true
end

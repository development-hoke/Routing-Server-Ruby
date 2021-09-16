# encoding: utf-8
# ------------------------------
# Setting モデル
# ------------------------------
class Setting < ApplicationRecord
  # バリデーション
  validates :notification_follow, inclusion: { in: [true, false] }
  validates :notification_like, inclusion: { in: [true, false] }
  validates :notification_comment, inclusion: { in: [true, false] }
end

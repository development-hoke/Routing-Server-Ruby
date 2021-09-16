# encoding: utf-8
# ------------------------------
# User モデル
# ------------------------------
class User < ApplicationRecord
  has_secure_password

  # UUIDでIDを生成する
  before_create :set_uuid

  # バリデーション
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :profile, length: { maximum: 160 }
  validates :sex, presence: true, sex: true
  validates :age, presence: true, numericality: true
  validates :area, presence: true, prefecture: true
  validates :address, length: { maximum: 50 }
  validates :mail_address, presence: true, email: true
  validates :onedate_id, onedate_id: true, if: proc { |s| s.onedate_id.present? }
  validates :user_attr, presence: true, user_attribute: true
  validates :status, presence: true, user_status: true

  # 画像アップロード
  # ファイル名を操作したいので、既存のものは使わない
  # mount_uploader :image_url, ImageUploader
  validate :image_url

  def set_uuid
    self.id = SecureRandom.uuid
  end
end

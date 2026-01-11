class Room < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  # 予約機能作成機能追加まで無効化
  # has_many :reservations, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end

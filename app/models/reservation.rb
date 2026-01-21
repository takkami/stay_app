class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :check_in, :check_out, :people, presence: true
  validates :people, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validate :check_in_must_be_today_or_later
  validate :check_out_must_be_after_check_in

  # 宿泊日数
  def nights
    return 0 if check_in.blank? || check_out.blank?
    (check_out - check_in).to_i
  end

  private

  def check_in_must_be_today_or_later
    return if check_in.blank?
    errors.add(:check_in, :invalid) if check_in < Date.current
  end

  def check_out_must_be_after_check_in
    return if check_in.blank? || check_out.blank?
    errors.add(:check_out, :invalid) if check_out <= check_in
  end
end

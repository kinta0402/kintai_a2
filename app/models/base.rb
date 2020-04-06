class Base < ApplicationRecord
  validates :base_number, presence: true, uniqueness: true, length: { in: 1..4 }
  validates :base_name, presence: true, length: { maximum: 50 }
  validates :attendance_type, presence: true, length: { maximum: 50 }
end

class Medicine < ApplicationRecord
  include Discard::Model

  has_many :medicine_dosing_times
  has_many :dosing_times, through: :medicine_dosing_times

  validates :name, presence: true
  validates :name, uniqueness: { scope: :discarded_at, case_sensitive: false }

  mount_uploader :image, MedicineImageUploader
end

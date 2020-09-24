class Medicine < ApplicationRecord
  has_many :medicine_dosing_times
  has_many :dosing_times, through: :medicine_dosing_times

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

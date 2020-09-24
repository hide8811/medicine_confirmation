class MedicineDosingTime < ApplicationRecord
  belongs_to :medicine
  belongs_to :dosing_time
end

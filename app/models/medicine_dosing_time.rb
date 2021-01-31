class MedicineDosingTime < ApplicationRecord
  include Discard::Model

  belongs_to :medicine
  belongs_to :dosing_time
end

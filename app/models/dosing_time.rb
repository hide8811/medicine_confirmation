class DosingTime < ApplicationRecord
  include Discard::Model

  belongs_to :care_receiver

  has_many :medicine_dosing_times
  has_many :medicines, through: :medicine_dosing_times

  with_options presence: true do |p|
    p.validates :timeframe, :time, uniqueness: { case_sensitive: false, scope: %i[care_receiver_id discarded_at] }
    p.validates :care_receiver_id
  end
end

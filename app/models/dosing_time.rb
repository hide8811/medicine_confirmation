class DosingTime < ApplicationRecord
  include Discard::Model

  belongs_to :care_receiver

  has_many :medicine_dosing_times
  has_many :medicines, through: :medicine_dosing_times

  with_options presence: true do |p|
    p.validates :time,      uniqueness: { case_sensitive: false, scope: :care_receiver_id }
    p.validates :timeframe, uniqueness: { case_sensitive: false, scope: :care_receiver_id }
    p.validates :care_receiver_id
  end
end

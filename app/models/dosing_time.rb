class DosingTime < ApplicationRecord
  belongs_to :care_receiver

  with_options presence: true do |p|
    p.validates :time,      uniqueness: { case_sensitive: false, scope: :care_receiver_id }
    p.validates :timeframe, uniqueness: { case_sensitive: false, scope: :care_receiver_id }
    p.validates :care_receiver_id
  end
end

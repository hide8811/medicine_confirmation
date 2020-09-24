class Take < ApplicationRecord
  belongs_to :user
  belongs_to :care_receiver

  with_options presence: true do |p|
    p.validates :dosing_timeframe
    p.validates :dosing_time

    p.validates :user_id
    p.validates :care_receiver_id
  end

  validates :execute, inclusion: { in: [true, false] }
end

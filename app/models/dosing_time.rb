class DosingTime < ApplicationRecord
  include Discard::Model

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :timeframe

  belongs_to :care_receiver

  has_many :medicine_dosing_times
  has_many :medicines, through: :medicine_dosing_times

  has_many :active_medicine_dosing_times, -> { where(discarded_at: nil) }, class_name: 'MedicineDosingTime'
  has_many :active_medicines, -> { order(:id) }, through: :active_medicine_dosing_times, source: :medicine

  with_options presence: true do |p|
    p.validates :timeframe_id, :time, uniqueness: { case_sensitive: false, scope: %i[care_receiver_id discarded_at] }
    p.validates :care_receiver_id
  end

  scope :list_fetch, ->(care_receiver) { kept.where(care_receiver_id: care_receiver.id).order(:timeframe_id).includes(:active_medicines) }
end

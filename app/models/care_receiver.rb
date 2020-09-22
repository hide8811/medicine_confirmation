class CareReceiver < ApplicationRecord
  has_many :dosing_times

  with_options presence: true do |p|
    p.validates :last_name
    p.validates :first_name
    p.validates :last_name_kana, format: { with: /\A[ぁ-んー－]+\z/ }
    p.validates :first_name_kana, format: { with: /\A[ぁ-んー－]+\z/ }
    p.validates :birthday
  end

  validates :enroll, inclusion: { in: [true, false] }
end

FactoryBot.define do
  factory :take do
    execute          { false }
    dosing_timeframe { '朝食後' }
    dosing_time      { Faker::Time.between(from: Time.now - 1, to: Time.now, format: :short) }

    user
    care_receiver
  end
end

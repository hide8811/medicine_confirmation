FactoryBot.define do
  factory :dosing_time do
    time      { Faker::Time.between(from: Time.now - 1, to: Time.now, format: :short) }
    timeframe { '朝食後' }

    care_receiver
  end
end

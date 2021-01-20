FactoryBot.define do
  factory :dosing_time do
    time      { Faker::Time.unique.between(from: DateTime.now - 1, to: DateTime.now).strftime('%H:%M') }
    timeframe { '朝食後' }

    care_receiver
  end
end

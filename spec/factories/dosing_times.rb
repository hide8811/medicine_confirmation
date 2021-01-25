FactoryBot.define do
  factory :dosing_time do
    time         { Faker::Time.unique.between(from: DateTime.now - 1, to: DateTime.now).strftime('%H:%M') }
    timeframe_id { Faker::Number.unique.between(from: 1, to: 19) }

    care_receiver
  end
end

FactoryBot.define do
  factory :take do
    execute { false }
    dosing_timeframe { "MyString" }
    dosing_time { "2020-09-23 12:02:47" }
    user { nil }
    care_receiver { nil }
  end
end

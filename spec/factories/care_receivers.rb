FactoryBot.define do
  factory :care_receiver do
    last_name       { Gimei.last.kanji }
    first_name      { Gimei.first.kanji }
    last_name_kana  { Gimei.last.hiragana }
    first_name_kana { Gimei.first.hiragana }
    birthday        { Faker::Date.birthday(min_age: 65, max_age: 120) }
    enroll          { true }
  end
end

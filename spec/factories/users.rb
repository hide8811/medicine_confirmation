FactoryBot.define do
  factory :user do
    employee_id         { Faker::Alphanumeric.unique.alphanumeric }
    password            { 'Test1234' }
    last_name           { Gimei.last.kanji }
    first_name          { Gimei.first.kanji }
    last_name_kana      { Gimei.last.hiragana }
    first_name_kana     { Gimei.first.hiragana }
  end
end

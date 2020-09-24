FactoryBot.define do
  factory :medicine do
    name  { Faker::Lorem.word }
    image { Faker::Lorem.characters(number: 10) }
    url   { Faker::Internet.url }
  end
end

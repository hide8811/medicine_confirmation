FactoryBot.define do
  factory :medicine do
    name  { Faker::Lorem.word }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/image/medicine-test_image.png')) }
    url   { Faker::Internet.url }
  end
end

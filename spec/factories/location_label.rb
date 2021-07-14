FactoryBot.define do
  factory :location_label do
    title { Faker::Color.color_name }
    location
  end
end

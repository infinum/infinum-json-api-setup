FactoryBot.define do
  factory :location do
    latitude { Faker::Number.between(from: -90, to: 90) }
    longitude { Faker::Number.between(from: -180, to: 180) }

    trait :fourth_quadrant do
      latitude { Faker::Number.between(from: -0.1, to: -90) }
      longitude { Faker::Number.between(from: -0.1, to: -180) }
    end
  end
end

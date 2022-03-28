FactoryBot.define do
  factory :has_many_child do
    name { Faker::Lorem.sentence }
    main { false }
    has_many_example
  end
end

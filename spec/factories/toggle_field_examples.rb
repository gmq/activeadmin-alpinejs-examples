FactoryBot.define do
  factory :toggle_field_example do
    name { "MyString" }
    has_description { false }
    description { "MyText" }
  end
end


FactoryBot.define do
  factory :category do
    title { "Category #{Faker::Number.number(2)}" }
    type { :category } # Use the enum value
    created_at { Time.zone.now }

    trait :with_subcategories do
      after(:create) do |category|
        create_list(:category, 2, type: :subcategory, parent_category: category)
      end
    end
  end
end

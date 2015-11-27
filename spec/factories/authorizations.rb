FactoryGirl.define do
  factory :authorization do
    user
    sequence(:provider) { |n| "provider #{n}" }
    sequence(:uid) { |n| "uid #{n}" }
  end
end

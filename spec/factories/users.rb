FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@mail.ru" }

  factory :user do
    email

    password '123456'
    password_confirmation '123456'
  end
end

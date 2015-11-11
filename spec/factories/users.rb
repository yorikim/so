FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@mail.ru" }

  factory :user do
    email

    password '12345678'
    password_confirmation '12345678'
  end

  factory :user_wrong_confirmation, class: User do
    email

    password '1234'
    password_confirmation '8765'
  end
end

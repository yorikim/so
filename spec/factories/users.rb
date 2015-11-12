FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@mail.ru" }

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'

    factory :user_with_questions do
      transient do
        questions_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:question_with_answers, evaluator.questions_count, user: user)
      end
    end
  end

  factory :user_wrong_confirmation, class: User do
    email

    password '1234'
    password_confirmation '8765'
  end


end

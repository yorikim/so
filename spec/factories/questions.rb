FactoryGirl.define do
  sequence(:question_title) { |n| "Question title #{n}" }
  sequence(:question_body) { |n| "Question body #{n}" }

  factory :question do
    user
    title { generate(:question_title) }
    body { generate(:question_body) }

    factory :question_with_answers do
      transient do
        answers_count 5
        user_answer user
      end

      after(:create) do |question, evaluator|
        # puts question.user.email
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end

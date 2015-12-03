FactoryGirl.define do

  factory :question do
    user
    sequence(:title) { |n| "Question title #{n}" }
    sequence(:body) { |n| "Question body #{n}" }

    factory :question_with_answers do
      transient do
        answers_count 4
      end

      after(:create) do |question, evaluator|
        create(:answer, question: question, user: question.user)
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

    factory :question_with_attachments do
      after(:create) do |question|
        question.attachments << create(:question_attachment)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end

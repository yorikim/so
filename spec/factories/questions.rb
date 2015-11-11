FactoryGirl.define do
  sequence(:question_title) { |n| "Question title #{n}" }
  sequence(:question_body) { |n| "Question body #{n}" }

  factory :question do
    user
    title { generate(:question_title) }
    body { generate(:question_body) }
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end

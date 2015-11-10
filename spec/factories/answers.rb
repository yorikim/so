FactoryGirl.define do
  sequence(:answer_title) { |n| "Answer title #{n}" }
  sequence(:answer_body)  { |n| "Answer body #{n}" }

  factory :answer do
    question
    title { generate(:answer_title) }
    body  { generate(:answer_body) }
  end

  factory :invalid_answer, class: 'Answer' do
    title nil
    body nil
  end
end

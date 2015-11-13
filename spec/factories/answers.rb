FactoryGirl.define do
  sequence(:answer_body)  { |n| "Answer body #{n}" }

  factory :answer do
    user
    question
    body  { generate(:answer_body) }
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end

FactoryGirl.define do
  sequence(:answer_body) { |n| "Answer body #{n}" }

  factory :answer do
    user
    question
    body { generate(:answer_body) }

    factory :answer_with_attachments do
      after(:create) do |answer|
        answer.attachments << create(:answer_attachment)
      end
    end
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end

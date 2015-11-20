FactoryGirl.define do


  factory :answer do
    user
    question
    sequence(:body) { |n| "Answer body #{n}" }

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

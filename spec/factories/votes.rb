FactoryGirl.define do
  factory :question_vote, class: 'Vote' do
    user
    association :voteable, factory: :question

    value 0
  end

  factory :answer_vote, class: 'Vote' do
    user
    association :voteable, factory: :answer

    value 0
  end
end

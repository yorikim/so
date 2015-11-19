FactoryGirl.define do
  factory :question_vote_up, class: 'Vote' do
    association :voteable, factory: :question
    value 1
    user
  end

  factory :answer_vote_up, class: 'Vote' do
    association :voteable, factory: :question
    value 1
    user
  end
end

FactoryGirl.define do
  factory :question_comment, class: 'Comment' do
    association :commentable, factory: :question
    user
    sequence(:body) {|n| "Comment ##{n}"}
  end

  factory :answer_comment, class: 'Comment' do
    association :commentable, factory: :answer
    user
    sequence(:body) {|n| "Comment ##{n}"}
  end

  factory :invalid_comment, class: 'Comment' do
    user nil
    body nil
  end
end

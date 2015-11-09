FactoryGirl.define do
  factory :answer do
    question
    title "MyString"
    body "MyText"
  end

  factory :answer_2 do
    question
    title "MyString 2"
    body "MyText 2"
  end
end

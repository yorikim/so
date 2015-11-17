FactoryGirl.define do
  factory :attachment do
    association :attachmentable, factory: :question
    file { File.open("#{Rails.root}/spec/support/fixtures/test1.txt") }
  end
end
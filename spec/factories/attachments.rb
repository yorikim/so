FactoryGirl.define do
  factory :question_attachment, class: 'Attachment' do
    association :attachmentable, factory: :question
    file { File.open(File.join(Rails.root, 'spec', 'support', 'fixtures', 'test1.txt')) }
  end

  factory :answer_attachment, class: 'Attachment' do
    association :attachmentable, factory: :question
    file { File.open(File.join(Rails.root, 'spec', 'support', 'fixtures', 'test1.txt')) }
  end
end
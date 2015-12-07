require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to(:question) }
  it { should belong_to(:user) }


  describe Answer do
    it_behaves_like 'votable model'
    it_behaves_like 'attachable model'
    it_behaves_like 'commentable model'
  end

  describe 'notify followers' do
    let(:question) { create(:question) }
    subject { build(:answer, question: question) }

    it_behaves_like 'notifiable model'

    def subscribed_question
      question
    end
  end

  describe 'notify author of question' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    it 'notifies after create' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(NotifyMailer).to receive(:notify_author).with(question.user).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)

      create(:answer, question: question)
    end
  end
end

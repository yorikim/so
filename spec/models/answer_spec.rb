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
end

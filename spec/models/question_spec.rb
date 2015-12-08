require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions) }
  it { should have_many(:followers) }
  it { should belong_to(:user) }

  describe Question do
    it_behaves_like 'votable model'
    it_behaves_like 'attachable model'
    it_behaves_like 'commentable model'
  end

  describe 'followers' do
    context 'after create' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }

      it 'adds author to followers ' do
        expect(question.followers).to eq [user]
      end
    end

    context 'manage followers' do
      let(:question) { create(:question) }
      let(:user) { create(:user) }
      let(:question_with_follower) { create(:question, followers: [user]) }

      it 'adds follower' do
        expect { question.add_follower!(user) }.to change { question.followers.count }.by(1)
      end

      it 'removes follower' do
        expect { question_with_follower.remove_follower!(user) }.to change { question_with_follower.followers.count }.by(-1)
      end
    end

    context 'notify followers' do
      subject { create(:question) }

      it_behaves_like 'notifiable model'

      def subscribed_question
        subject
      end
    end
  end
end

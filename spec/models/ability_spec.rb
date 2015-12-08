require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :manage, create(:question, user: user), user: user }
    it { should_not be_able_to :manage, create(:question), user: user }

    it { should be_able_to :manage, create(:answer, user: user), user: user }
    it { should_not be_able_to :manage, create(:answer), user: user }

    it { should be_able_to :manage, create(:question_comment, user: user), user: user }
    it { should_not be_able_to :manage, create(:question_comment), user: user }

    it { should be_able_to :manage, create(:question_attachment, attachable: question), user: user }
    it { should_not be_able_to :manage, create(:question_attachment), user: user }

    it { should be_able_to :vote, create(:question, user: other), user: user }
    it { should_not be_able_to :vote, create(:question, user: user), user: user }

    it { should be_able_to :vote, create(:answer, user: other), user: user }
    it { should_not be_able_to :vote, create(:answer, user: user), user: user }

    it { should be_able_to :me, user }
    it { should_not be_able_to :me, other }

    it { should be_able_to :subscribe, create(:question), user: user }
    it { should_not be_able_to :subscribe, create(:question, followers: [user]), user: user }

    it { should be_able_to :unsubscribe, create(:question, followers: [user]), user: user }
    it { should_not be_able_to :unsubscribe, create(:question), user: user }
  end
end

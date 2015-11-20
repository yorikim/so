require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :value }

  it { should belong_to :user }
  it { should belong_to :voteable }

  describe 'change value' do
    let!(:vote) { create(:question_vote) }

    it 'from -1 to 0' do
      vote.value = -1
      expect { vote.change_value(1) }.to change { vote.value }.by(1)
    end

    it 'from 0 to 1' do
      vote.value = 0
      expect { vote.change_value(1) }.to change { vote.value }.by(1)
    end

    it 'from 1 to 1' do
      vote.value = 1
      expect { vote.change_value(1) }.to change { vote.value }.by(0)
    end

    it 'from 1 to 0' do
      vote.value = 1
      expect { vote.change_value(-1) }.to change { vote.value }.by(-1)
    end

    it 'from 0 to -1' do
      vote.value = 0
      expect { vote.change_value(-1) }.to change { vote.value }.by(-1)
    end

    it 'from -1 to -1' do
      vote.value = -1
      expect { vote.change_value(-1) }.to change { vote.value }.by(0)
    end
  end
end

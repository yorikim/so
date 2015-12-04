require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }


  describe Question do
    it_behaves_like 'votable model'
    it_behaves_like 'attachable model'
    it_behaves_like 'commentable model'
  end
end

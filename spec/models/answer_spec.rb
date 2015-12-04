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
end

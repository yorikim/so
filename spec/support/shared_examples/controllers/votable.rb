shared_examples_for 'votable controller' do |model_class|
  let(:model_sym) { model_class.to_s.underscore.to_sym }

  let(:user) { create(:user) }
  let(:own_subject) { create(model_sym, user: user) }
  let(:foreign_subject) { create(model_sym) }

  before { sign_in user }

  describe 'POST #vote_up' do
    it "increase vote value for the foreign subject" do
      post :vote_up, id: foreign_subject
      foreign_subject.reload
      expect(foreign_subject.vote_value).to eq 1
    end

    it 'response JSON object' do
      post :vote_up, id: foreign_subject
      expect(response.body).to be_json_eql({vote_value: 1, vote_status: 1}.to_json)
    end

    it "vote up the own subject" do
      expect { post :vote_up, id: own_subject }.to_not change(Vote, :count)
    end
  end

  describe 'POST #vote_down' do
    it "decrease vote value for the foreign subject" do
      post :vote_down, id: foreign_subject
      foreign_subject.reload
      expect(foreign_subject.vote_value).to eq -1
    end

    it 'response JSON object' do
      post :vote_down, id: foreign_subject
      expect(response.body).to be_json_eql({vote_value: -1, vote_status: -1}.to_json)
    end

    it 'vote down the own question' do
      expect { post :vote_down, id: own_subject }.to_not change(Vote, :count)
    end
  end
end
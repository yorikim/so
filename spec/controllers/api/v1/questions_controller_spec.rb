require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  include Devise::TestHelpers

  def do_request_show(options = {})
    question = create(:question)
    get :show, {id: question, format: :json}.merge(options)
  end

  def do_request_ndex(options = {})
    get :index, {format: :json}.merge(options)
  end

  def do_request_create(options = {})
    post :create, {question: attributes_for(:question), format: :json}.merge(options)
  end

  it_behaves_like 'API Authenticable controller'


  describe ' GET /index ' do
    context ' authorized ', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }

      before { get :index, format: :json, access_token: access_token.token }

      it 'returns questions' do
        expect(response.body).to be_json_eql(questions.to_json).at_path('questions')
      end
    end
  end

  describe 'POST /create' do
    context ' authorized ' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid attributes', :lurker do
        it 'creates a new question' do
          expect { post :create, question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new question' do
          expect { post :create, question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }.to_not change(Question, :count)
        end

        it 'returns 422 code' do
          post :create, question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          should respond_with(422)
        end
      end
    end
  end
end
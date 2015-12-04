require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  include Devise::TestHelpers

  let(:question) { create(:question) }

  describe ' GET /index ' do
    context ' authorized ', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answers) { create_list(:answer, 5, question: question) }

      before { get :index, question_id: question, format: :json, access_token: access_token.token }

      it 'returns answers' do
        expect(response.body).to be_json_eql(answers.to_json).at_path('answers')
      end
    end
  end

  describe 'POST /create' do
    context ' authorized ' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid attributes', :lurker do
        it 'creates a new answer' do
          expect { post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(question.answers, :count).by(1)
        end

        it 'assigns to user' do
          post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response.body).to be_json_eql(me.id).at_path('answer/user_id')
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new answer' do
          expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }.to_not change(Answer, :count)
        end

        it 'returns 422 code' do
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          should respond_with(422)
        end
      end
    end
  end

  def do_request_show(options = {})
    answer = create(:answer, question: question)
    get :show, {question_id: question, id: answer, format: :json}.merge(options)
  end

  def do_request_index(options = {})
    get :index, {question_id: question, format: :json}.merge(options)
  end

  def do_request_create(options = {})
    post :create, {question_id: question, answer: attributes_for(:answer), format: :json}.merge(options)
  end

  it_behaves_like 'API Authenticable'
end
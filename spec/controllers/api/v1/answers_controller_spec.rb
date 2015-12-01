require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  include Devise::TestHelpers

  let(:question) { create(:question) }

  describe ' GET /show' do
    let(:answer) { create(:answer, question: question) }

    context ' unathorized ' do
      it ' returns 401 status if there is no access_token ' do
        get :show, question_id: question, id: answer, format: :json
        should respond_with 401
      end

      it ' returns 401 status if access_token is invalid ' do
        get :show, question_id: question, id: answer, format: :json, access_token: ' 1234 '
        should respond_with 401
      end
    end

    context ' authorized ', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:answer_comment, commentable: answer) }
      let!(:attachment) { create(:answer_attachment, attachable: answer) }

      before { get :show, question_id: question, id: answer, format: :json, access_token: access_token.token }

      %w(id body question_id user_id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it 'returns success code ' do
        expect(response).to be_success
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it "attachment object contains file" do
          expect(response.body).to be_json_eql(attachment.send(:file).to_json).at_path("answer/attachments/0/file")
        end
      end
    end
  end

  describe ' GET /index ' do
    context ' unathorized ' do
      it ' returns 401 status if there is no access_token ' do
        get :index, question_id: question, format: :json
        should respond_with 401
      end

      it ' returns 401 status if access_token is invalid ' do
        get :index, question_id: question, format: :json, access_token: ' 1234 '
        should respond_with 401
      end
    end

    context ' authorized ', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answers) { create_list(:answer, 5, question: question) }
      let(:answer) { answers.first }

      before { get :index, question_id: question, format: :json, access_token: access_token.token }

      it 'returns answers' do
        expect(response.body).to be_json_eql(answers.to_json).at_path('answers')
      end

       %w(id body user_id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    context ' unathorized ' do
      it ' returns 401 status if there is no access_token ' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: ' 1234 '
        should respond_with 401
      end

      it ' returns 401 status if access_token is invalid ' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: ' 1234 '
        should respond_with 401
      end
    end

    context ' authorized ' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid attributes', :lurker do
        it 'creates a new answer' do
          expect { post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(question.answers, :count).by(1)
        end

        it 'returns success code ' do
          post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to be_success
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
end
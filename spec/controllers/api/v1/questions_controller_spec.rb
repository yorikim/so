require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  include Devise::TestHelpers

  describe ' GET /show' do
    let(:question) { create(:question) }

    context ' unathorized ' do
      it ' returns 401 status if there is no access_token ' do
        get :show, id: question, format: :json
        should respond_with 401
      end

      it ' returns 401 status if access_token is invalid ' do
        get :show, id: question, format: :json, access_token: ' 1234 '
        should respond_with 401
      end
    end

    context ' authorized ', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:question) { create(:question) }
      let!(:comment) { create(:question_comment, commentable: question) }
      let!(:attachment) { create(:question_attachment, attachable: question) }

      before { get :show, id: question, format: :json, access_token: access_token.token }

      %w(id title body user_id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it 'returns success code ' do
        expect(response).to be_success
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it "comment object contains file" do
          expect(response.body).to be_json_eql(attachment.send(:file).to_json).at_path("question/attachments/0/file")
        end
      end
    end
  end

  describe ' GET /index ' do
    context ' unathorized ' do
      it ' returns 401 status if there is no access_token ' do
        get :index, format: :json
        should respond_with 401
      end

      it ' returns 401 status if access_token is invalid ' do
        get :index, format: :json, access_token: ' 1234 '
        should respond_with 401
      end
    end

    context ' authorized ', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }

      before { get :index, format: :json, access_token: access_token.token }

      it 'returns questions' do
        expect(response.body).to be_json_eql(questions.to_json).at_path('questions')
      end

      %w(id title body user_id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    context ' unathorized ' do
      it ' returns 401 status if there is no access_token ' do
        post :create, question: attributes_for(:question), format: :json, access_token: ' 1234 '
        should respond_with 401
      end

      it ' returns 401 status if access_token is invalid ' do
        post :create, question: attributes_for(:question), format: :json, access_token: ' 1234 '
        should respond_with 401
      end
    end

    context ' authorized ' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid attributes', :lurker do
        it 'creates a new question' do
          expect { post :create, question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(me.questions, :count).by(1)
        end

        it 'returns success code ' do
          post :create, question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response).to be_success
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
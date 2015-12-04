require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "POST #create" do
    login_user
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }

    context 'with valid attributes' do
      context 'question' do
        let(:request) { post :create, question_id: question, comment: attributes_for(:question_comment), format: :json }

        it 'should add comment to the question' do
          expect { request }.to change(question.comments, :count).by(1)
          should respond_with(201)
        end

        it_behaves_like 'publicable controller', /^\/questions\/\d+\/comments\/new$/
      end

      context 'question' do
        let(:request) { post :create, answer_id: answer, comment: attributes_for(:answer_comment), format: :json }

        it 'should add comment to the answer' do
          expect { request }.to change(answer.comments, :count).by(1)
          should respond_with(201)
        end

        it_behaves_like 'publicable controller', /^\/questions\/\d+\/answers\/comments\/new$/
      end
    end

    context 'with invalid attributes' do
      it "shouldn't create a comment" do
        expect { post :create, question_id: question, comment: attributes_for(:invalid_comment), format: :json }.to_not change(Comment, :count)
        expect { post :create, answer_id: answer, comment: attributes_for(:invalid_comment), format: :json }.to_not change(Comment, :count)
      end

      it 'should render with 422' do
        expect { post :create, question_id: question, comment: attributes_for(:invalid_comment), format: :json }.to_not change(Comment, :count)
        should respond_with(422)

        expect { post :create, answer_id: answer, comment: attributes_for(:invalid_comment), format: :json }.to_not change(Comment, :count)
        should respond_with(422)
      end
    end
  end
end

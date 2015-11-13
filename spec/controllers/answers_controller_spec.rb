require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question_with_answers) }

  describe 'POST #create' do
    login_user :user_with_questions

    context 'with valid attributes' do
      it 'creates a new answer to the question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        should render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'render temaple create' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        should render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user :user_with_questions
    let!(:own_question) { @user.questions.first }
    let(:own_answer) { own_question.answers.first }

    it 'remove own answer' do
      expect { delete :destroy, question_id: own_question, id: own_answer }.to change(own_question.answers, :count).by(-1)
      should redirect_to question_path(own_question)
    end

    let!(:another_user) { create(:user_with_questions) }
    let(:foreign_question) { another_user.questions.first }
    let(:foreign_answer) { foreign_question.answers.first }

    it 'not remove foreign question' do
      expect { delete :destroy, question_id: foreign_question, id: foreign_answer }.to_not change(Answer, :count)
      should redirect_to question_path(foreign_question)
    end
  end
end
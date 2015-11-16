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

  describe 'PATCH #update' do
    login_user :user
    let(:own_question) { create(:question, user: @user) }
    let(:foreign_question) { create(:question) }

    let(:own_answer) { create(:answer, question: foreign_question, user: @user) }
    let(:foreign_answer) { create(:answer, question: own_question) }

    context 'with valid attributes' do
      before { patch :update, question_id: foreign_question, id: own_answer, answer: {body: 'new body'}, format: :js }

      it 'assings the requested answer to @answer' do
        expect(assigns(:answer)).to eq own_answer
      end

      it 'assigns to question' do
        expect(assigns(:question)).to eq foreign_question
      end

      it 'edit the question' do
        own_answer.reload
        expect(own_answer.body).to eq 'new body'
      end

      it 'render template update' do
        should render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, question_id: foreign_question, id: own_answer, answer: {body: nil}, format: :js }

      it 'edit the question' do
        question.reload

        expect(own_answer.body).to_not eq nil
      end

      it 'render template edit' do
        should render_template :update
      end
    end

    it 'trying to update the foreign answer' do
      patch :update, question_id: own_question, id: foreign_answer, answer: {body: 'new body'}, format: :js
      foreign_question.reload

      expect(own_answer.body).to_not eq 'new body'
    end
  end

  describe 'DELETE #destroy' do
    login_user :user_with_questions
    let!(:own_question) { @user.questions.first }
    let(:own_answer) { own_question.answers.first }

    it 'remove own answer' do
      expect { delete :destroy, question_id: own_question, id: own_answer, format: :js }.to change(own_question.answers, :count).by(-1)
      should render_template :destroy
    end

    let!(:another_user) { create(:user_with_questions) }
    let(:foreign_question) { another_user.questions.first }
    let(:foreign_answer) { foreign_question.answers.first }

    it 'not remove foreign question' do
      expect { delete :destroy, question_id: foreign_question, id: foreign_answer, format: :js }.to_not change(Answer, :count)
      should render_template :destroy
    end
  end
end
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question_with_answers) }

  describe 'GET #new' do
    login_user :user_with_questions

    before { get :new, question_id: question }

    it 'assings a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    login_user :user_with_questions

    context 'with valid attributes' do
      it 'creates a new answer to the question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to view Questions#show' do
        post :create, question_id: question, answer: attributes_for(:answer)

        answer = assigns(:answer)
        should redirect_to question_path(id: answer.question_id)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-render view #new' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        should render_template :new
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
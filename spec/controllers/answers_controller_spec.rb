require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }

    before { get :show, question_id: question, id: answer }

    it 'assings the requested answer to @answer' do
      expect(assigns(:answer)).to eq (answer)
    end

    it { should render_template :show }
  end

  describe 'GET #new' do
    login_user

    before { get :new, question_id: question }

    it 'assings a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'creates a new answer to the question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to view #show' do
        post :create, question_id: question, answer: attributes_for(:answer)

        answer = assigns(:answer)
        should redirect_to question_answer_path(question_id: answer.question_id, id: answer)
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

  # describe 'DELETE #destroy' do
  #   login_user(:user_with_questions)
  #
  #   let(:question) { @user.questions.first }
  #   let(:answer) { question.answers.first }
  #
  #   it 'remove own answer' do
  #     expect { delete :destroy, id: answer }.to change(@user, :count).by(-1)
  #     should redirect_to questions_path
  #   end
  #
  #   let(:another_user) { create(:user_with_questions) }
  #   let(:foreign_question) { create(another_user.questions.first) }
  #   let(:foreign_answer) { another_user.questions.first }
  #
  #   it 'not remove foreign question' do
  #     expect { delete :destroy, id: foreign_answer }.to raise_exception(ActiveRecord::RecordNotFound)
  #   end
  # end
end
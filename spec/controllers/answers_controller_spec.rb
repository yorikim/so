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
    context 'logged user' do
      login_user

      before { get :new, question_id: question }

      it 'assings a new answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it { should render_template :new }
    end
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
end
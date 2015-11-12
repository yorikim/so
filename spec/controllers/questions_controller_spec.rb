require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'insert an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it { should render_template('index') }
  end

  describe 'GET #show' do
    let(:user) { create(:user_with_questions) }
    let(:question) { user.questions.first }
    let(:answers) { question.answers }

    before { get :show, id: question }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq (question)
    end

    it 'assigns the included answers to @question.answers' do
      expect(assigns(:question).answers).to match_array(answers)
    end

    it { should render_template :show }
  end

  describe 'GET #new' do
    context 'logged user' do
      login_user

      before { get :new }

      it 'assings a new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it { should render_template :new }
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'creates a new question' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to view #show' do
        post :create, question: attributes_for(:question)
        should redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-render view #new' do
        post :create, question: attributes_for(:invalid_question)
        should render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user(:user_with_questions)
    let(:question) { @user.questions.first }

    it 'remove own question' do
      expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
      should redirect_to questions_path
    end

    let!(:another_user) { create(:user_with_questions) }
    let(:foreign_question) { another_user.questions.first }

    it 'not remove foreign question' do
      expect { delete :destroy, id: foreign_question }.to_not change(Question, :count)
      should redirect_to questions_path
    end
  end
end

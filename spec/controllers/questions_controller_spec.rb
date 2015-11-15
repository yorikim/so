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
      expect(assigns(:question).answers).to include(*answers)
    end

    it 'assigns a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
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

  describe 'PATCH #update' do
    login_user :user
    let(:question) { create(:question, user: @user) }
    let(:foreign_question) { create(:question) }

    context 'with valid attributes' do
      it 'edit the question' do
        patch :update, id: question, question: {title: 'new title', body: 'new body'}, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render template update' do
        patch :update, id: question, question: {title: 'new title', body: 'new body'}, format: :js
        should render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'edit the question' do
        patch :update, id: question, question: {title: nil, body: nil}, format: :js
        question.reload

        expect(question.title).to_not eq nil
        expect(question.body).to_not eq nil
      end

      it 'render template edit' do
        patch :update, id: question, question: {title: nil, body: nil}, format: :js
        should render_template :update
      end
    end

    it 'trying to update them foreign question' do
      patch :update, id: foreign_question, question: {title: 'new title', body: 'new body'}, format: :js
      foreign_question.reload

      expect(question.title).to_not eq 'new title'
      expect(question.body).to_not eq 'new body'
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

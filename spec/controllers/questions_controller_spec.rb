require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'votable controller', Question

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before do
      sign_out :user
      get :index
    end

    it 'insert an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it { should render_template('index') }
  end

  describe 'GET #show' do
    let(:user) { create(:user_with_questions) }
    let(:question) { user.questions.first }
    let(:answers) { question.answers }

    before do
      sign_out :user
      get :show, id: question
    end

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq (question)
    end

    it 'assigns the included answers to @question.answers' do
      expect(assigns(:question).answers).to include(*answers)
    end

    it 'assigns a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new comment' do
      expect(assigns(:question).comments.first).to be_a_new(Comment)
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

      it 'builds new attachment for question' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end

      it { should render_template :new }
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      let(:request) { post :create, question: attributes_for(:question) }

      it 'creates a new question' do
        expect { request }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to view #show' do
        request
        should redirect_to question_path(assigns(:question))
      end

      it_behaves_like 'publicable controller', '/questions/new'
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

  describe 'POST #subscribe' do
    context 'authenticated user' do
      login_user

      let!(:question) { create(:question) }

      it 'follows the subject' do
        expect { post :subscribe, id: question.id, format: :js }.to change { question.followers.count }.by(1)
        should render_template :subscribe
      end

      it 'renders template :subscribe' do
        post :subscribe, id: question.id, format: :js
        should render_template :subscribe
      end
    end
  end

  context 'POST #update' do
    login_user

    let(:question) { create(:question, user: @user) }
    let(:request) { patch :update, id: question, question: attributes_for(:question), format: :js }

    it_behaves_like 'notifiable controller'
  end
end

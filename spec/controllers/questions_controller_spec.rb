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
    let(:question) { create(:question) }

    before do
      get :show, id: question
    end

    it 'assings the requested question to @questions' do
      expect(assigns(:question)).to eq (question)
    end

    it { should render_template :show }
  end

  describe 'GET #new' do
    before do
      get :new
    end

    it 'assings a new question to @questions' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new question' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
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
end

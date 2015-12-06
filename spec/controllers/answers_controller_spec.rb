require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'votable controller', Answer

  let!(:question) { create(:question) }

  describe 'POST #create' do
    login_user :user_with_questions

    context 'with valid attributes' do
      let(:request) { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
      let(:notify_subject) { question }

      it 'creates a new answer to the question' do
        expect { request }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        request
        should render_template :create
      end

      it 'notifies author' do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(NotifyMailer).to receive(:notify_author).with(question.user).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        request
      end

      it_behaves_like 'publicable controller', /^\/questions\/\d+\/answers\/new$/
      it_behaves_like 'notifiable controller'
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
      before { patch :update, id: own_answer, answer: {body: 'new body'}, format: :js }

      it 'assings the requested answer to @answer' do
        expect(assigns(:answer)).to eq own_answer
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

  describe 'POST #best_answer' do
    login_user :user
    let(:own_question) { create(:question, user: @user) }
    let(:foreign_question) { create(:question) }

    let(:own_answer) { create(:answer, question: foreign_question, user: @user) }
    let(:foreign_answer) { create(:answer, question: own_question) }

    context 'own question' do
      before { post :make_best, question: own_question, id: foreign_answer, format: :js }

      it 'should update question' do
        own_question.reload
        expect(own_question.best_answer.id).to eq foreign_answer.id
      end

      it { should render_template :make_best }
    end

    context 'foreign question' do
      before { post :make_best, question: foreign_question, id: own_answer, format: :js }

      it 'not marks as best answer' do
        expect(own_answer.best).to eq false
      end

      it { should render_template :make_best }
    end
  end

  describe 'DELETE #destroy', js: true do
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

    it 'not remove foreign answer' do
      expect { delete :destroy, id: foreign_answer, format: :js }.to_not change(Answer, :count)
      should render_template :destroy
    end
  end
end
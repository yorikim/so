class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :vote_up, :vote_down]

  include VoteableController

  before_action :load_question, only: [:show, :update, :destroy, :vote_up, :vote_down]
  before_action :build_answer, only: :show
  before_action :build_comment, only: :show

  after_action :build_attachment, only: [:new]
  after_action :public_question, only: :create

  respond_to :html
  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def show
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end


  private

  def load_question
    @question = Question.find(params[:id])
    @obj = @question
  end

  def build_answer
    @answer = @question.answers.build
  end

  def build_comment
    @comment = @question.comments.build
  end

  def build_attachment
    @attachment = @question.attachments.build
  end

  def public_question
    PrivatePub.publish_to "/questions/new", question: @question.to_json(only: [:id, :title], methods: :vote_value)
  end

  def question_params
    params.require(:question).permit(
        :title,
        :body,
        attachments_attributes: [:file, :_destroy, :id],
    )
  end
end

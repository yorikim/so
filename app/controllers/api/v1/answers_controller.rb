class Api::V1::AnswersController < Api::V1::ApplicationController
  authorize_resource
  before_action :load_question

  def index
    respond_with @question.answers.order(:id), each_serializer: AnswerCollectionSerializer
  end

  def show
    respond_with @question.answers.find(params[:id])
  end

  def create
    authorize! :create, Answer
    respond_with @question.answers.create(answer_params.merge(user: current_resource_owner))
  end


  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(
        :body,
    )
  end
end

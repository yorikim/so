class AnswersController < ApplicationController
  before_action :authenticate_user!

  include VoteableController

  before_action :load_answer, except: [:create]
  before_action :load_question, only: [:create, :make_best]
  before_action only: [:update, :destroy] { check_permissions!(@answer) }
  before_action only: [:make_best] { check_permissions!(@question) }

  after_action :public_answer, only: :create

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params) { |a| a.user = current_user })
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def make_best
    respond_with(@answer.mark_as_best)
  end

  def destroy
    respond_with(@answer.destroy)
  end


  private

  def public_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers/new", answer: @answer.to_json
  end

  def load_question
    if params[:question_id]
      @question = Question.find(params[:question_id])
    else
      @question = @answer.question
    end
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @obj = @answer
  end

  def answer_params
    params.require(:answer).permit(
        :body,
        attachments_attributes: [:file, :_destroy, :id],
    )
  end

end

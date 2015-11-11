class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_filter :load_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to [@question, @answer], notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.find(params[:id])
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(
        :title,
        :body,
    )
  end
end

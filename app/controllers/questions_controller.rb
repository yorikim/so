class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
  end

  private

  def question_params
    params.require(:question).permit(
        :title,
        :body,
    )
  end
end

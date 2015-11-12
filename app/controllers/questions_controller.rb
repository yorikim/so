class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
  end

  def destroy
    @question = current_user.questions.find_by(id: params[:id])

    notice = 'You have no authority to remove this question.'
    if @question
      @question.destroy
      notice = 'Your question successfully removed.'
    end

    redirect_to questions_path, notice: notice
  end

  private

  def question_params
    params.require(:question).permit(
        :title,
        :body,
    )
  end

end

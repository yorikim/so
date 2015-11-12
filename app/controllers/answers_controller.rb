class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :load_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])

    notice = 'You have no authority to remove this answer.'
    if @answer and @answer.user_id == current_user.id
      @answer.destroy
      notice = 'Your answer successfully removed.'
    end

    redirect_to question_path(@question), notice: notice
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

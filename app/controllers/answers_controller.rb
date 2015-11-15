class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    if @answer.user_id == current_user.id
      @answer.update(answer_params)
    else
      @answer.errors.add(:base, 'You have no authority to edit this answer.')
    end
  end

  def destroy
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

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(
        :body,
    )
  end
end

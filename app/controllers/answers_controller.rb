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

  def best_answer
    if @question.user_id == current_user.id
      @question.set_best_answer!(@answer)
    else
      @answer.errors.add(:base, 'You have no authority to set best answer.')
    end
  end

  def destroy
    if @answer and @answer.user_id == current_user.id
      @question.remove_best_answer if @question.best_answer_id == @answer.id
      @answer.destroy
    else
      @answer.errors.add(:base, 'You have no authority to remove this answer.')
    end
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

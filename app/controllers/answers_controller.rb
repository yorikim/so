class AnswersController < ApplicationController
  before_action :authenticate_user!

  include VoteableController

  before_action :load_question
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
    @comment = @answer.comments.build
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      @answer.errors.add(:base, 'You have no authority to edit this answer.')
    end
  end

  def best_answer
    if current_user.author_of?(@question)
      @answer.mark_as_best
      @comment = @answer.comments.build
    else
      flash[:notice] = 'You have no authority to set best answer.'
    end
  end

  def destroy
    if @answer && current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:notice] = 'You have no authority to remove this answer.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
    @obj = @answer
  end

  def answer_params
    params.require(:answer).permit(
        :body,
        attachments_attributes: [:file, :_destroy, :id],
    )
  end

end

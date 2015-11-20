class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :load_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      flash[:notice] = 'You have no authority to edit this question.'
    end
  end

  def destroy
    notice = 'You have no authority to remove this question.'
    if current_user.author_of?(@question)
      @question.destroy
      notice = 'Your question successfully removed.'
    end

    redirect_to questions_path, notice: notice
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
        :title,
        :body,
        attachments_attributes: [:file, :_destroy, :id],
    )
  end

end

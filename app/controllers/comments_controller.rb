class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      PrivatePub.publish_to "#{comments_path}/comments/new", comment: @comment.to_json
      render nothing: true
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end


  private

  def comments_path
    case @commentable_name
      when 'question'
        "/questions/#{params[:question_id]}"
      when 'answer'
        answer = Answer.find(params[:answer_id])
        "/questions/#{answer.question_id}/answers"
    end
  end

  def load_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable_name = $1
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

  def comment_params
    params.require(:comment).permit(
        :body
    )
  end
end
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      PrivatePub.publish_to "#{comments_path}/comments/new", comment: @comment.to_json

      render nothing: true, :status => 200
    else
      render nothing: true, :status => 500
    end
  end


  private

  def comments_path
    case @commentable_name
      when 'question'
        "/questions/#{params[:question_id]}"
      when 'answer'
        "/questions/#{params[:question_id]}/answers"
    end
  end

  def load_commentable
    parent_klasses = %w[answer question]

    if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
      @commentable_name = klass
      @commentable = klass.camelize.constantize.find params[:"#{klass}_id"]
    end
  end

  def comment_params
    params.require(:comment).permit(
        :body
    )
  end
end
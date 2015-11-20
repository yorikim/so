module VoteableController
  extend ActiveSupport::Concern

  def vote_up
    vote(:up)
  end

  def vote_down
    vote(:down)
  end

  protected

  def vote(type)
    if !current_user.author_of?(@obj) && @obj.send("vote_#{type}", current_user)
      @vote = @obj.votes.find_by(user: current_user)
      render json: {vote_value: @obj.vote_value, vote_status: @vote.value}
    else
      render json: {status: :unprocessable_entity}
    end
  end
end
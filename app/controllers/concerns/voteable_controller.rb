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
    if @obj.send("vote_#{type}", current_user)
      @vote = @obj.votes.find_by(user: current_user)
    end
    @vote ||= @obj.votes.build

    if @vote.errors.empty?
      render json: {vote_value: @obj.vote_value, vote_status: @vote.value}
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end
end
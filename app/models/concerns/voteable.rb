module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end

  def vote_value
    votes.sum(:value)
  end

  def vote_up(user)
    make_vote(user, 1)
  end

  def vote_down(user)
    make_vote(user, -1)
  end

  protected

  def make_vote(user, value)
    unless self.new_record?
      vote = votes.find_or_create_by(user: user)
      vote.change_value(value)
    end
  end
end
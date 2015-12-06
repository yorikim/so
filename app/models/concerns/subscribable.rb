module Subscribable
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :followers, class_name: 'User'
  end

  def follower?(user)
    followers.include? user
  end

  def add_follower!(user)
    followers << user unless follower?(user)
  end
end
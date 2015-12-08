class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable
  include Notifiable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :followers, through: :subscriptions, source: :user

  validates :user_id, :title, :body, presence: true

  after_create :add_author_to_followers
  after_commit :notify_followers

  scope :created_yesterday, -> { where(created_at: (Date.today - 1.day)..Date.today) }

  def best_answer
    answers.find_by(best: true)
  end

  def follower?(user)
    followers.include? user
  end

  def add_follower!(user)
    followers << user unless follower?(user)
  end

  def remove_follower!(user)
    followers.delete(user) if follower?(user)
  end

  private

  def add_author_to_followers
    followers << user
  end

  def question
    self
  end
end
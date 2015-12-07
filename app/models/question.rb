class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable
  include Notifiable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :followers, through: :subscriptions, source: :user#, class_name: 'User'

  validates :user_id, :title, :body, presence: true

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
    followers.delete(user)# if follower?(user)
  end
end
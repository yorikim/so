class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable
  include Subscribable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user_id, :title, :body, presence: true

  scope :created_yesterday, -> { where(created_at: (Date.today - 1.day)..Date.today) }

  def best_answer
    answers.find_by(best: true)
  end
end
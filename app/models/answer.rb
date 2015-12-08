class Answer < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable
  include Notifiable

  belongs_to :user
  belongs_to :question

  after_create :notify_followers

  validates :user_id, :question_id, :body, presence: true

  def mark_as_best
    question.answers.update_all({best: false})
    update_attribute(:best, true)
  end
end

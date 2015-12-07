class Answer < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable
  include Notifiable

  delegate :followers, to: :question

  belongs_to :user
  belongs_to :question

  after_create :notify_author
  after_create :notify_followers

  validates :user_id, :question_id, :body, presence: true

  def mark_as_best
    question.answers.update_all({best: false})
    update_attribute(:best, true)
  end

  def notify_author
    NotifyMailer.notify_author(question.user).deliver_later
  end
end

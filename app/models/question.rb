class Question < ActiveRecord::Base
  include Attachmentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user_id, :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end

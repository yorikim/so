class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user_id, :title, :body, presence: true

  def best_answer
    answers.where('answers.id = ?', best_answer_id)
  end

  def answers_without_best
    answers.where('(? is null) or (answers.id <> ?)', best_answer_id, best_answer_id)
  end

  def set_best_answer!(answer)
    update_attribute(:best_answer_id, answer.id)
  end
end

class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, :class_name => "Answer",
             :foreign_key => :best_answer_id

  validates :user_id, :title, :body, presence: true

  def answers_without_best
    answers.where('answers.id <> coalesce(?, 0)', best_answer_id)
  end

  def set_best_answer!(answer)
    update_attribute(:best_answer_id, answer.id)
  end

  def remove_best_answer
    update_attribute(:best_answer_id, nil)
  end
end

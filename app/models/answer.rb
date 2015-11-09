class Answer < ActiveRecord::Base
  belongs_to :question

  validates :question_id, :title, :body, presence: true
end

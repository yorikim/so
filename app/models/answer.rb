class Answer < ActiveRecord::Base
  belongs_to :question

  validates :question, :title, :body, presence: true
end

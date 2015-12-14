class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true

  def search_label
    'C:'
  end

  def question
    commentable.question
  end
end

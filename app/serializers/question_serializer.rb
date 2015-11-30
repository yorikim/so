class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :body, :updated_at, :created_at

  has_many :comments
  has_many :attachments
end
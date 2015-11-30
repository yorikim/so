class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :user_id, :body, :best, :updated_at, :created_at

  has_many :comments
  has_many :attachments
end
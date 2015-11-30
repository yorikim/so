class AnswerCollectionSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :user_id, :body, :best, :updated_at, :created_at
end
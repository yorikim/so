class QuestionCollectionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :body, :updated_at, :created_at
end
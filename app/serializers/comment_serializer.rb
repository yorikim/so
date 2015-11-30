class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :updated_at, :created_at
end
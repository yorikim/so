class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file, :updated_at, :created_at
end

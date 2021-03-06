class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true, touch: true

  mount_uploader :file, FileUploader

  validates :file, presence: true
end

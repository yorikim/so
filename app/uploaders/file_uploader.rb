# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  delegate :filename, to: :file

  # include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end

# frozen_string_literal: true
require 'rmagick'
require 'securerandom'
require 'mime/types'

class ImageResizer
  def execute(file, max_size)
    img = Magick::ImageList.new(file)
    image_mime_type = MIME::Types[img.mime_type].first
    temporary_filepath = "/tmp/#{SecureRandom.uuid}.#{image_mime_type.preferred_extension}"
    img.resize_to_fit(max_size, max_size).write(temporary_filepath) do |opt|
      opt.quality = 60
    end
    temporary_filepath
  end
end

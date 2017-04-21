module ActiveadminSettings
  module PictureMethods

    def self.included(base)
      # Features
      base.mount_uploader :data, ActiveadminSettings::RedactorPictureUploader
    end

    # Helpers
    def has_dimensions?
      respond_to?(:width) && respond_to?(:height)
    end

    def image?
      ActiveadminSettings::IMAGE_TYPES.include?(data_content_type)
    end

    def url
      data.url
    end

    def image
      url
    end

    def thumb
      data.thumb.url
    end

    def as_json_methods
      [:image, :thumb]
    end

    def as_json(options = nil)
      options = {
        :methods => as_json_methods
      }
      super options
    end
  end

  class Picture < ActiveRecord::Base

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :data_content_type, :data_file_size, :height, :width, :data
    end

    include PictureMethods

    # Scopes
    default_scope { order('created_at desc') }
  end
end

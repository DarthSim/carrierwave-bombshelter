require 'carrierwave/bombshelter/version'

require 'fastimage'
require 'i18n'
require 'carrierwave'

files = Dir[File.expand_path(
  '../../locale/*.yml', __FILE__
)]
I18n.load_path = files.concat I18n.load_path

module CarrierWave
  module BombShelter
    extend ActiveSupport::Concern

    included do
      # `before` puts callback in the end of queue, but we need to run this
      # callback first.
      # before :cache, :protect_from_image_bomb!
      self._before_callbacks = _before_callbacks.merge(
        cache: [:protect_from_image_bomb!] + _before_callbacks[:cache]
      )
    end

    def max_pixel_dimensions
      [4096, 4096]
    end

    private

    def protect_from_image_bomb!(new_file)
      image = FastImage.new(new_file.path || get_real_file(new_file.file))
      check_image_type!(image)
      check_pixel_dimensions!(image)
    end

    def check_image_type!(image)
      return if image.type
      raise CarrierWave::IntegrityError,
            I18n.translate(:'errors.messages.not_image')
    end

    def check_pixel_dimensions!(image)
      max_sizes = max_pixel_dimensions

      return if image.size &&
                image.size[0] <= max_sizes[0] &&
                image.size[1] <= max_sizes[1]

      raise CarrierWave::IntegrityError,
            I18n.translate(
              :'errors.messages.pixel_dimensions_error',
              x_size: max_sizes[0], y_size: max_sizes[1]
            )
    end

    def get_real_file(file)
      return file unless file.is_a? CarrierWave::SanitizedFile
      get_real_file(file.file)
    end
  end
end

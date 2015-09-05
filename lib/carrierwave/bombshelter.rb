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
      before :cache, :check_pixel_dimensions!
    end

    def max_pixel_dimensions
      [4096, 4096]
    end

    private

    def check_pixel_dimensions!(new_file)
      sizes = FastImage.size(new_file.path)
      max_sizes = max_pixel_dimensions

      return if !sizes || (sizes[0] <= max_sizes[0] && sizes[1] <= max_sizes[1])

      fail CarrierWave::IntegrityError,
           I18n.translate(
             :'errors.messages.pixel_dimensions_error',
             x_size: max_sizes[0], y_size: max_sizes[1]
           )
    end
  end
end

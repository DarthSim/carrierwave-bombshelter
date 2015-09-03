$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'carrierwave/bombshelter'

require 'minitest/autorun'

class TestBombShelter < Minitest::Test
  class TestUploader < CarrierWave::Uploader::Base
    include CarrierWave::BombShelter

    def root
      File.expand_path('../../tmp', __FILE__)
    end

    def max_pixel_dimentions
      [5, 5]
    end
  end

  def fixture_file(name)
    File.open(File.expand_path("../fixtures/#{name}", __FILE__))
  end

  def subject
    @subject ||= TestUploader.new
  end

  def test_small_img
    subject.store!(fixture_file('small.png'))
    subject.store!(fixture_file('small.jpg'))
  end

  def test_big_img
    assert_raises(CarrierWave::IntegrityError) do
      subject.store!(fixture_file('big.png'))
    end
  end
end

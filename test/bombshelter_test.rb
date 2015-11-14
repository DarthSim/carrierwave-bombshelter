$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'carrierwave/bombshelter'

require 'minitest/autorun'
require 'webmock/minitest'

class TestBombShelter < Minitest::Test
  class TestUploader < CarrierWave::Uploader::Base
    include CarrierWave::BombShelter

    def root
      File.expand_path('../../tmp', __FILE__)
    end

    def max_pixel_dimensions
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

  def test_not_image
    assert_raises(CarrierWave::IntegrityError) do
      subject.store!(fixture_file('not_image.png'))
    end
  end

  def test_small_remote
    stub_request(:get, 'http://example.com/small.png')
      .to_return(status: 200, body: fixture_file('small.png'))
    stub_request(:get, 'http://example.com/big.png')
      .to_return(status: 200, body: fixture_file('big.png'))

    subject.download!('http://example.com/small.png')
    assert_raises(CarrierWave::IntegrityError) do
      subject.download!('http://example.com/big.png')
    end
  end

  def test_sanitized_sanitized_file
    subject.store!(
      CarrierWave::SanitizedFile.new(
        CarrierWave::SanitizedFile.new(fixture_file('small.jpg'))
      )
    )
  end

  def test_callbeck_setup
    uploader = Class.new(CarrierWave::Uploader::Base)
    refute_includes(
      uploader._before_callbacks[:cache], :protect_from_image_bomb!
    )
  end
end

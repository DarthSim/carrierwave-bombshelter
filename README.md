# CarrierWave::BombShelter

[![Build Status](https://travis-ci.org/DarthSim/carrierwave-bombshelter.svg)](https://travis-ci.org/DarthSim/carrierwave-bombshelter)

BombShelter is a module which protects your uploaders from [image bombs](https://www.bamsoftware.com/hacks/deflate.html). It checks pixel dimensions of uploaded image before ImageMagick touches it.

<a href="https://evilmartians.com/">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

## How it works

BombShelter uses [fastimage](https://github.com/sdsykes/fastimage) gem, which reads just a header of an image to get info about it. BombShelter compares pixel dimensions of the uploaded image with maximum allowed ones and raises integrity error if image is too big. Works perfectly with ActiveRecord validators.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-bombshelter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-bombshelter

## Usage

Just include `CarrierWave::BombShelter` to your uploader and you're done:

```ruby
class YourUploader < CarrierWave::Uploader::Base
  include CarrierWave::BombShelter
end
```

By default BombShelter sets maximum allowed dimensions to 4096x4096, but you can set your own ones by defining `max_pixel_dimensions` method:

```ruby
class YourUploader < CarrierWave::Uploader::Base
  include CarrierWave::BombShelter

  def max_pixel_dimensions
    [1024, 1024]
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DarthSim/carrierwave-bombshelter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

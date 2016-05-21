TransformTree
---
[![Build Status](https://travis-ci.org/ffleming/transform_tree.svg?branch=master)](https://travis-ci.org/ffleming/transform_tree)
[![Code Climate](https://codeclimate.com/github/ffleming/transform_tree/badges/gpa.svg)](https://codeclimate.com/github/ffleming/transform_tree)
[![Test Coverage](https://codeclimate.com/github/ffleming/transform_tree/badges/coverage.svg)](https://codeclimate.com/github/ffleming/transform_tree/coverage)

TransformTree provides an API for buildng trees of closures and executing those closures on provided input.  This allows users to output all possible combinations of their desired transformations.  A small library of useful transformations is included.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transform_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transform_tree

## Usage
```ruby
tree = TransformTree::TransformRoot.new
upcase = ->(o) { o.upcase }
downcase = ->(o) { o.downcase }
append_s = ->(o) { "#{o}s" }
append_exc = ->(o) { "#{o}!" }

tree.add_transform(upcase, downcase, TransformTree::Transforms.null)
tree.add_transform(append_s, append_exc, TransformTree::Transforms.null)
tree.execute('Woof')
```
```ruby
 => ["WOOFs", "WOOF!", "WOOF", "woofs", "woof!", "woof", "Woofs", "Woof!", "Woof"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ffleming/transform_tree.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


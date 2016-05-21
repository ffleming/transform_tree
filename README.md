TransformTree
---
[![Build Status](https://travis-ci.org/ffleming/transform_tree.svg?branch=master)](https://travis-ci.org/ffleming/transform_tree)
[![Code Climate](https://codeclimate.com/github/ffleming/transform_tree/badges/gpa.svg)](https://codeclimate.com/github/ffleming/transform_tree)
[![Gem Version](https://badge.fury.io/rb/transform_tree.svg)](https://badge.fury.io/rb/transform_tree)

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

tree.add_transform(upcase, downcase, TransformTree::Transforms::null)
tree.add_transform(append_s, append_exc, TransformTree::Transforms::null)
tree.execute('Woof')
```
```ruby
 => ["WOOFs", "WOOF!", "WOOF", "woofs", "woof!", "woof", "Woofs", "Woof!", "Woof"]
```

For full code examples, see integration specs in `/spec/integrations`.

### Provided transforms
The `TransformTree::Transforms` module provides some useful transformations.  `ret` can be used to initially split your tree into distinct values, which are to be operated on later, e.g.
```ruby
closures = superlatives.map {|w| TransformTree::Transforms::ret(w)}
tree.add_transforms(*closures)
```

If you prefer, you can build the tree without using `Transforms::ret` and instead simply make multiple calls to `#execute`, passing an object to process each time.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ffleming/transform_tree.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


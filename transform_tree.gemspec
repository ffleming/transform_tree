# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transform_tree/version'

Gem::Specification.new do |spec|
  spec.name          = 'transform_tree'
  spec.version       = TransformTree::VERSION
  spec.authors       = ['Forrest Fleming']
  spec.email         = ['ffleming@gmail.com']

  spec.summary       = 'TransformTree is a library for combining arbitrary transformations on objects.'
  spec.description   = 'TransformTree provides an API for buildng trees of closures and executing those '\
    'closures on provided input.  This allows users to output all possible combinations of their desired '\
    'transformations.  A small library of useful transformations is included.'
  spec.homepage      = 'https://github.com/ffleming/transform_tree'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug', '~> 3.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.5'
end

require "transform_tree/version"
require "transform_tree/transform_node"
require "transform_tree/transform_root"

module TransformTree
  module Transforms
    class << self
      def null
        ->(o = nil){ o }
      end

      def ret(arg)
        ->(o = nil) { arg }
      end
    end
  end
end

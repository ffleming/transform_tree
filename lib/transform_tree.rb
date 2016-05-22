require "transform_tree/version"
require "transform_tree/node"
require "transform_tree/root"

module TransformTree
  module Transforms
    class << self
      def null
        @null ||= ->(o = nil) { o }
      end

      def ret(arg)
        @ret ||= {}
        @ret[arg] ||= ->(_ = nil) { arg }
      end
    end
  end
end

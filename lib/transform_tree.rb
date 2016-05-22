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
        @ret[arg.object_id] ||= ->(_ = nil) { arg }
      end

      def append(arg)
        @append ||= {}
        @append[arg.object_id] ||= ->(o = nil) { o + arg }
      end

      def prepend(arg)
        @prepend ||= {}
        @prepend[arg.object_id] ||= ->(o = nil) { arg + o }
      end
    end
  end
end

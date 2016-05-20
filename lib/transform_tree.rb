require "transform_tree/version"
require "transform_tree/transform_node"

module TransformTree
  class TransformRoot
    def initialize
      @root = TransformNode.new ->(o){o}
    end

    def levels
      node = root
      while !node.children.empty?
        node = node.children.first
      end
      node.level + 1
    end

    def add_transform(*closures)
      root.add_transform(*closures)
      self
    end

    def execute(obj)
      root.execute(obj)
    end
    attr_reader :root
  end
end

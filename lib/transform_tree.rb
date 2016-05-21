require "transform_tree/version"
require "transform_tree/transform_node"

module TransformTree
  NULL = ->(o){o}
  class TransformRoot < TransformNode
    def initialize
      super(TransformTree::NULL, 0)
    end

    def add_transform(*closures)
      super(*closures)
    end

    def report
      super
    end

    def height
      leaves.first.level + 1
    end

    def execute(*args)
      super(*args)
    end

    alias_method :add_transforms, :add_transform

  end

end

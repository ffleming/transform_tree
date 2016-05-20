require "transform_tree/version"
require "transform_tree/transform_node"

module TransformTree
  attr_reader :root
  def initialize(closure)
    @root = TransformNode.new closure
  end
end

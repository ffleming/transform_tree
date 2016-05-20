require 'byebug'
require 'pry-byebug'
class TransformTree::TransformNode
  attr_reader :closure, :children, :level
  def initialize(closure, level = 0)
    @closure = closure
    @children = []
    @level = level
  end

  def add_transform(*closures)
    if children.empty?
      closures.each do |closure|
        children << self.class.new(closure, level + 1)
      end
    else
      children.each do |child|
        child.add_transform(*closures)
      end
    end
    self
  end

  def report(built='')
    built << "#{' ' * level}#{level}\n"
    children.each {|child| child.report(built) }
    built
  end

  def levels
    node = self
    while !node.children.empty?
      node = node.children.first
    end
    node.level + 1
  end

  def to_a(built=[])
    built << self
    children.each {|child| child.to_a(built) }
    built
  end

  def count
    to_a.count
  end

  def nodes

  end

  def outputs
    leaves.count
  end

  def leaves(memo=[])
    (memo << self) if children.empty?
    children.each {|child| child.leaves(memo) }
    memo
  end

  private

end


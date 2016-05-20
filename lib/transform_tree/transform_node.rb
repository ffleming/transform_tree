require 'byebug'
require 'pry-byebug'
class TransformTree::TransformNode
  attr_reader :closure, :children, :level

  def initialize(closure, level = 0)
    @closure = closure
    @level = level
    @children = []
  end

  def add_transform(*closures)
    leaves.each do |leaf|
      closures.each do |closure|
        leaf.children << self.class.new(closure, leaf.level + 1)
      end
    end
    self
  end

  def execute(obj, memo = [])
    children.each { |child| child.execute(closure.call(obj), memo) }
    memo << closure.call(obj) if children.empty?
    memo
  end

  def report(built='')
    built << "#{' ' * level}#{level}\n"
    children.each {|child| child.report(built) }
    built
  end

  def to_a(built=[])
    built << self
    children.each {|child| child.to_a(built) }
    built
  end

  def count
    to_a.count
  end

  def outputs
    leaves.count
  end

  alias_method :add_transforms, :add_transform
  private

  def leaves(memo=[])
    (memo << self) if children.empty?
    children.each {|child| child.leaves(memo) }
    memo
  end

end

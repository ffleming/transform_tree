class TransformTree::Node
  protected
  attr_reader :children, :closure, :level

  def initialize(closure, level = 0)
    @closure = closure
    @level = level
    @children = []
  end

  def add_transform(*closures)
    leaves.each do |leaf|
      closures.each do |closure|
        leaf.children << TransformTree::Node.new(closure, leaf.level + 1)
      end
    end
    self
  end

  def execute(obj, ret = [])
    children.each { |child| child.execute(closure.call(obj), ret) }
    ret << closure.call(obj) if children.empty?
    ret
  end

  def report(built='')
    closure_info = "#{File.basename closure.source_location.first}:#{closure.source_location.last}"
    built << "#{' ' * level}#{level} - #{closure_info}\n"
    children.each {|child| child.report(built) }
    built
  end

  def leaves(ret=[])
    (ret << self) if children.empty?
    children.each {|child| child.leaves(ret) }
    ret
  end
end

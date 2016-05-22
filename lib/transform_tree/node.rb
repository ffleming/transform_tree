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

  def report(built='', padding = [])
    built << report_line(padding)
    children.each {|child| child.report(built, padding + [child != children.last]) }
    built
  end

  def leaves(ret=[])
    (ret << self) if children.empty?
    children.each {|child| child.leaves(ret) }
    ret
  end

  private

  # padding is an array of booleans. an elements index in the array is the level of the tree; an element's
  # value is true iff that level is 'live' (ie it has more elements to display)
  # marker in the column corresponding to that boolean's index in the array
  def report_line(padding)
    return "#{closure_info}\n" if padding.empty?
    padding_chars = padding.each_with_index.with_object('') do |(el, i), acc|
      acc << "   " unless i == 0         # align first branch under root (mimic Unix `tree`)
      next if (i+1) >= padding.count     # don't display | for the final item, as we'll use ├ or └
      acc << (el ? '|' : ' ')            # display | if corresponding level is still 'live'
    end
    "#{padding_chars }#{ padding.last ? '├' : '└' }──#{closure_info}\n"
  end

  def closure_info
    "#{File.basename closure.source_location.first}:#{closure.source_location.last}"
  end
end

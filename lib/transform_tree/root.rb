module TransformTree
  class Root < Node
    attr_reader :height
    def initialize
      super(TransformTree::Transforms.null, 0)
      @height = 0
    end

    def add_transform(*closures)
      @height += 1
      super(*closures)
    end

    def report
      super
    end

    def execute(*args)
      args = [nil] if args.empty?
      super(*args)
    end

    alias_method :add_transforms, :add_transform
  end
end

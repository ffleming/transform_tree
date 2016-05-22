require 'spec_helper'
RSpec.describe 'Integrations' do
  describe "Creating a Hashcat mask" do
    it 'should transform properly' do
      # Input words to be transformed
      superlatives = [ 'rules', 'is number one', 'is number 1',
                'is # one', 'is # 1', 'is awesome', 'is the best',
                'rocks', 'forever' ]

      # Create transforming closures
      titleize = lambda do |str|
        str.split(/ /).map { |w| "#{w[0].upcase}#{w[1..-1]}" }.join
      end
      hc_mask = ->(str) { "$#{str.split(//).join('$')}" }
      semi_titleize = lambda do |str|
        ret = titleize.call(str)
        "#{ret[0].downcase}#{ret[1..-1]}"
      end

      tree = TransformTree::TransformRoot.new

      # Rather than executing the tree several times with each input, we can use the provide #ret transform
      # to split the root into input to be processed
      closures = superlatives.map { |w| TransformTree::Transforms::ret(w) }
      tree.add_transforms(*closures)

      # split on whitespace removal
      tree.add_transforms(
        TransformTree::Transforms::null,
        ->(s) { s.delete(' ') }
      )

      # Split each input into 4: titleized, semi-titleized, upcased, and downcased
      # Note that you can use #add_transform or #add_transforms
      tree.add_transform(
        titleize,
        semi_titleize,
        ->(w) { w.upcase },
        ->(w) { w.downcase }
      )

      # The provided null transform simply preserves the input
      tree.add_transform(
        TransformTree::Transforms::null,
        ->(w) { "#{w}!" }
      )

      # Providing a single transform means that every leaf is transformed - there is no split
      tree.add_transform(hc_mask)
      processed = tree.execute('')

      expect(processed).to include '$I$s$N$u$m$b$e$r$O$n$e$!', '$R$u$l$e$s',
        '$f$o$r$e$v$e$r$!', '$i$s$a$w$e$s$o$m$e'
    end
  end
end

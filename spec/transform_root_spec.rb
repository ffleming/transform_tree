require 'spec_helper'

RSpec.describe TransformTree::TransformRoot do
  let(:closure) { ->(o) { o } }
  let(:twice) { ->(n) { n * 2 }  }
  let(:append) { ->(s) { "#{s}A" } }
  let(:prepend) { ->(s) { "P#{s}" } }
  let(:sum_and_product) { ->(a, b) { [a + b, a * b] } }

  let(:single) { TransformTree::TransformRoot.new }
  let(:two) { TransformTree::TransformRoot.new.add_transform(twice) }
  let(:split_tree) { TransformTree::TransformRoot.new.add_transform(twice).add_transform(append, prepend) }
  let(:large) do
    r = TransformTree::TransformRoot.new
    2.times { r.add_transform(append, prepend) }
    r
  end
  let :huge do
    r = TransformTree::TransformRoot.new.add_transform(twice)
    5.times { r.add_transform(twice, append) }
    r
  end

  describe '#initialize' do
    it 'should not raise an error' do
      expect { TransformTree::TransformRoot.new }.to_not raise_error
    end
  end

  describe '#execute' do
    it 'should DFS through each transformation path, yielding the correct result' do
      expect(split_tree.execute('test')).to include 'testtestA', 'Ptesttest'
      expect(large.execute('_')).to include '_AA', 'P_A', 'PP_'
    end

    it 'should be able to take no argument (as when used with `ret` transform)' do
      expect(large.execute).to include 'AA', 'PA', 'PP'
    end
  end

  describe '#report' do
    it 'should ouput correctly' do
      huge_expected = "0\n 1\n  2\n   3\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n" \
        "    4\n     5\n      6\n      6\n     5\n      6\n      6\n   3\n    4\n     5\n      6\n" \
        "      6\n     5\n      6\n      6\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n" \
        "  2\n   3\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n    4\n     5\n      6\n" \
        "      6\n     5\n      6\n      6\n   3\n    4\n     5\n      6\n      6\n     5\n      6\n" \
        "      6\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n"
      aggregate_failures do
        expect(single.report).to eq "0\n"
        expect(two.report).to eq "0\n 1\n"
        expect(split_tree.report).to eq "0\n 1\n  2\n  2\n"
        expect(large.report).to eq "0\n 1\n  2\n  2\n 1\n  2\n  2\n"
        expect(huge.report).to eq huge_expected
      end
    end
  end

  describe '#height' do
    it 'should return the tree\'s height' do
      aggregate_failures do
        expect(single.height).to eq 0
        expect(two.height).to eq 1
        expect(split_tree.height).to eq 2
        expect(large.height).to eq 2
        expect(huge.height).to eq 6
      end
    end
  end

  describe '#add_transform' do
    let(:tree) { TransformTree::TransformRoot.new }

    it 'should be chainable' do
      expect { tree.add_transform(:closure).add_transform(:close) }.to_not raise_error
    end

    it "should alter the object's state" do
      expect(tree.add_transform(:closure)).to be tree
    end

    it 'should increase the height' do
      expect { tree.add_transform(:closure) }.to change { tree.height }.by 1
    end
  end

  describe '#add_transforms' do
    it 'should respond' do
      expect(single).to respond_to :add_transforms
    end
  end
end

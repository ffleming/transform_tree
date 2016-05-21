require 'spec_helper'

RSpec.describe TransformTree::TransformRoot do
  let(:closure) { ->(o){o}  }
  let(:twice) { ->(n){n = n * 2}  }
  let(:append) { ->(s) {s = "#{s}A"} }
  let(:prepend) { ->(s) {s = "P#{s}"} }

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

  it 'should not raise an error' do
    expect{TransformTree::TransformRoot.new}.to_not raise_error
  end

  describe '#execute' do
    it 'should DFS through each transformation path, yielding the correct result' do
      expect(split_tree.execute('test').sort).to eq ["testtestA", "Ptesttest"].sort
      expect(large.execute('_').sort).to eq ["_AA", "P_A", "P_A", "PP_"].sort
    end
  end

  describe '#report' do
    it 'should ouput correctly' do
      huge_expected = "0\n 1\n  2\n   3\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n" <<
        "    4\n     5\n      6\n      6\n     5\n      6\n      6\n   3\n    4\n     5\n      6\n" <<
        "      6\n     5\n      6\n      6\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n" <<
        "  2\n   3\n    4\n     5\n      6\n      6\n     5\n      6\n      6\n    4\n     5\n      6\n" <<
        "      6\n     5\n      6\n      6\n   3\n    4\n     5\n      6\n      6\n     5\n      6\n" <<
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
    it 'should return the number of levels/height (1-indexed)' do
      aggregate_failures do
        expect(single.height).to eq 0
        expect(two.height).to eq 1
        expect(split_tree.height).to eq 2
        expect(large.height).to eq 2
        expect(huge.height).to eq 6
      end
    end
  end

  describe '#leaves' do
    it 'should return the leaves' do
      aggregate_failures do
        expect(single.leaves.count).to eq 1
        expect(two.leaves.count).to eq 1
        expect(split_tree.leaves.count).to eq 2
        expect(large.leaves.count).to eq 4
        expect(huge.leaves.count).to eq 32
      end
    end
  end

  describe '#add_transform'

end

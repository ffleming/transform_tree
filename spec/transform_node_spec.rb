require 'spec_helper'

RSpec.describe TransformTree::TransformNode do
  let(:closure) { ->{}  }

  let(:root) { TransformTree::TransformNode.new(closure) }
  let(:two) { TransformTree::TransformNode.new(closure).add_transform(closure) }
  let(:binary) { TransformTree::TransformNode.new(closure).add_transform(closure, closure) }
  let(:large) do
    r = TransformTree::TransformNode.new(closure)
    2.times { r.add_transform(closure, closure) }
    r
  end
  let :huge do
    r = TransformTree::TransformNode.new(closure)
    5.times { r.add_transform(closure, closure) }
    r
  end

  it 'should not raise an error' do
    expect{TransformTree::TransformNode.new(->{})}.to_not raise_error
  end

  describe '#report' do
    it 'should ouput correctly' do
      huge_expected = "0\n 1\n  2\n   3\n    4\n     5\n     5\n" <<
      "    4\n     5\n     5\n   3\n    4\n     5\n     5\n    4\n" <<
      "     5\n     5\n  2\n   3\n    4\n     5\n     5\n    4\n" <<
      "     5\n     5\n   3\n    4\n     5\n     5\n    4\n     5\n" <<
      "     5\n 1\n  2\n   3\n    4\n     5\n     5\n    4\n     5\n" <<
      "     5\n   3\n    4\n     5\n     5\n    4\n     5\n     5\n" <<
      "  2\n   3\n    4\n     5\n     5\n    4\n     5\n     5\n " <<
      "  3\n    4\n     5\n     5\n    4\n     5\n     5\n"
      aggregate_failures do
        expect(root.report).to eq "0\n"
        expect(two.report).to eq "0\n 1\n"
        expect(binary.report).to eq "0\n 1\n 1\n"
        expect(large.report).to eq "0\n 1\n  2\n  2\n 1\n  2\n  2\n"
        expect(huge.report).to eq huge_expected
      end
    end
  end

  describe '#levels' do
    it 'should return the number of levels (1-indexed)' do
      aggregate_failures do
        expect(root.levels).to eq 1
        expect(two.levels).to eq 2
        expect(binary.levels).to eq 2
        expect(large.levels).to eq 3
        expect(huge.levels).to eq 6
      end
    end
  end

  describe '#to_a' do
    it 'should have the correct number of elements' do
      aggregate_failures do
        expect(root.to_a.count).to eq 1
        expect(two.to_a.count).to eq 2
        expect(binary.to_a.count).to eq 3
        expect(large.to_a.count).to eq 7
        expect(huge.to_a.count).to eq 63
      end
    end
  end

  describe '#to_a' do
    it 'should count the elements' do
      aggregate_failures do
        expect(root.count).to eq 1
        expect(two.count).to eq 2
        expect(binary.count).to eq 3
        expect(large.count).to eq 7
        expect(huge.count).to eq 63
      end
    end
  end

  describe '#leaves' do
    it 'should return the leaves' do
      aggregate_failures do
        expect(root.leaves.count).to eq 1
        expect(two.leaves.count).to eq 1
        expect(binary.leaves.count).to eq 2
        expect(large.leaves.count).to eq 4
        expect(huge.leaves.count).to eq 32
      end
    end
  end

  describe '#add_transform'

end


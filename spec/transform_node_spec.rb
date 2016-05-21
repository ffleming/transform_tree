require 'spec_helper'

RSpec.describe TransformTree::TransformNode do
  let(:closure) { ->(o){o}  }
  let(:twice) { ->(n){n = n * 2}  }
  let(:append) { ->(s) {s = "#{s}A"} }
  let(:prepend) { ->(s) {s = "P#{s}"} }

  let(:single) { TransformTree::TransformNode.new(closure) }
  let(:two) { TransformTree::TransformNode.new(closure).add_transform(twice) }
  let(:split_tree) { TransformTree::TransformNode.new(twice).add_transform(append, prepend) }
  let(:large) do
    r = TransformTree::TransformNode.new(closure)
    2.times { r.add_transform(append, prepend) }
    r
  end
  let :huge do
    r = TransformTree::TransformNode.new(twice)
    5.times { r.add_transform(twice, append) }
    r
  end

  before(:each) do
    TransformTree::TransformNode.send(:public, *(TransformTree::TransformNode.protected_instance_methods))
  end

  it 'should not raise an error' do
    expect{TransformTree::TransformNode.new(->{})}.to_not raise_error
  end

  describe '#execute' do
    it 'should execute each node in to obtain an output' do
      expect(split_tree.execute('test').sort).to eq ["testtestA", "Ptesttest"].sort
      expect(large.execute('_').sort).to eq ["_AA", "P_A", "P_A", "PP_"].sort
    end
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
        expect(single.report).to eq "0\n"
        expect(two.report).to eq "0\n 1\n"
        expect(split_tree.report).to eq "0\n 1\n 1\n"
        expect(large.report).to eq "0\n 1\n  2\n  2\n 1\n  2\n  2\n"
        expect(huge.report).to eq huge_expected
      end
    end
  end

end


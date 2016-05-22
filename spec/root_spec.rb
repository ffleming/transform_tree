require 'spec_helper'

RSpec.describe TransformTree::Root do
  let(:closure) { ->(o) { o } }
  let(:twice) { ->(n) { n * 2 }  }
  let(:append) { ->(s) { "#{s}A" } }
  let(:prepend) { ->(s) { "P#{s}" } }
  let(:sum_and_product) { ->(a, b) { [a + b, a * b] } }

  let(:single) { TransformTree::Root.new }
  let(:two) { TransformTree::Root.new.add_transform(twice) }
  let(:split_tree) { TransformTree::Root.new.add_transform(twice).add_transform(append, prepend) }
  let(:large) do
    r = TransformTree::Root.new
    2.times { r.add_transform(append, prepend) }
    r
  end
  let :huge do
    r = TransformTree::Root.new.add_transform(twice)
    5.times { r.add_transform(twice, append) }
    r
  end

  describe '#initialize' do
    it 'should not raise an error' do
      expect { TransformTree::Root.new }.to_not raise_error
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
      aggregate_failures do
        lines = huge.report.split("\n")
        expect(huge.report).to be_a String
        expect(lines.count).to be 64
        expect(lines.last).to match( / {20}└──root_spec.rb:\d+/)
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
    let(:tree) { TransformTree::Root.new }

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

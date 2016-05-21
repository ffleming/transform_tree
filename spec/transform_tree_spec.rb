require 'spec_helper'

describe TransformTree do
  it 'has a version number' do
    expect(TransformTree::VERSION).not_to be nil
  end

  describe 'Provided transformations' do
    describe 'return lambdas that...' do
      describe '#null' do
        it 'should have identical input and output' do
          input = 'woof'
          lam = TransformTree::Transforms.null
          expect(lam.call(input)).to be input
        end
      end

      describe '#ret' do
        it 'should return whatever was passed as an argument to #ret' do
          arg = 'woof'
          lam = TransformTree::Transforms.ret(arg)
          expect(lam.call).to be arg
        end

      end
    end
  end
end

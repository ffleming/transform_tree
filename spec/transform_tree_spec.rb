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

        it 'should return the same object on each call' do
          lam = TransformTree::Transforms.null
          expect(TransformTree::Transforms.null).to be lam
        end
      end

      describe '#ret' do
        it 'should return whatever was passed as an argument to #ret' do
          arg = 'woof'
          lam = TransformTree::Transforms.ret(arg)
          expect(lam.call).to be arg
        end

        it 'should return the same object on each call with identical parameters' do
          str_lam = TransformTree::Transforms.ret('test')
          arr_lam = TransformTree::Transforms.ret(%i(test array))
          aggregate_failures do
            expect(TransformTree::Transforms.ret('test')).to be str_lam
            expect(TransformTree::Transforms.ret(%i(test array))).to be arr_lam
            expect(TransformTree::Transforms.ret('other')).to_not be str_lam
            expect(TransformTree::Transforms.ret('other')).to_not be arr_lam
          end
        end
      end
    end
  end
end

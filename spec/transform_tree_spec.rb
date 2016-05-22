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

        it 'should return the same object on each call with object-identical parameters' do
          str_lam_arg = 'test'
          str_lam = TransformTree::Transforms.ret(str_lam_arg)
          arr_lam_arg = %i(test array)
          arr_lam = TransformTree::Transforms.ret(arr_lam_arg)
          aggregate_failures do
            expect(TransformTree::Transforms.ret(str_lam_arg)).to be str_lam
            expect(TransformTree::Transforms.ret(arr_lam_arg)).to be arr_lam
            expect(TransformTree::Transforms.ret('other')).to_not be str_lam
            expect(TransformTree::Transforms.ret('other')).to_not be arr_lam
          end
        end
      end

      describe '#append' do
        let(:append_arg) { 'arf' }
        let(:lam) do
          TransformTree::Transforms.append(append_arg)
        end

        it 'should append the called argument' do
          expect(lam.call('woof')).to eq "woof#{append_arg}"
        end

        it 'should cache the lambda appropriately' do
          expect(TransformTree::Transforms.append(append_arg)).to be lam
        end

        it 'should call :+ on object passed as arg to lambda' do
          lam_arg = 'woof'
          expect(lam_arg).to receive(:+).with(append_arg).once
          lam.call(lam_arg)
        end
      end

      describe '#prepend' do
        let(:prepend_arg) { 'arf' }
        let(:lam) do
          TransformTree::Transforms.prepend(prepend_arg)
        end

        it 'should prepend the called argument' do
          expect(lam.call('woof')).to eq "#{prepend_arg}woof"
        end

        it 'should cache the lambda appropriately' do
          expect(TransformTree::Transforms.prepend(prepend_arg)).to be lam
        end

        it 'should call :+ on object passed as arg to #prepend' do
          lam_arg = 'woof'
          expect(prepend_arg).to receive(:+).with(lam_arg).once
          lam.call(lam_arg)
        end
      end
    end
  end
end

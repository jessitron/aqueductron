require_relative '../lib/aqueductron'
require 'generative'

module Aqueductron
  describe Duct do
    describe 'the last data point' do
      let(:input) { ["one","two","three"]}
      let(:new_builder) { Duct.new() }
      let(:builder) { new_builder }

      subject { builder.last.flow(input).value }

      describe 'giving an answer' do
        it { should == input.last }
      end

      describe 'empty data' do
        let(:input) { [] }
        it { should == :no_data}
      end

    end

    describe 'it can be limited - examples' do
      let(:input) { ["one","two","three"]}
      let(:new_builder) { Duct.new() }
      let(:how_many) { 2 }
      let(:builder) { new_builder }

      subject { builder.take(how_many).last.flow(input).value }

      describe 'giving an answer' do
        it { should == 'two' }
      end

      describe 'can be limited to too many' do
        let (:how_many) { 8}
        it { should == 'three'}
      end

      describe 'can be limited to 1' do
        let (:how_many) { 1}
        it { should == 'one'}
      end

      describe 'zero always gets no data' do
        let(:how_many) {0}
        it { should == :no_data}
      end

    end

    generative 'it can be limited' do
      data(:input_len) { Generators.small_int }
      data(:input) { Generators.array_of(Generators.method(:alpha_char), input_len)}
      data(:how_many) { Generators.small_int }

      subject { Duct.new.take(how_many).last.flow(input).value }

      it 'gives the last one in the truncated output' do
        if (how_many == 0 || input_len == 0) then
          subject.should == :no_data
        elsif (how_many >= input_len) then
          subject.should == input.last
        else
          subject.should == input[how_many - 1]
        end
      end
    end
  end
end


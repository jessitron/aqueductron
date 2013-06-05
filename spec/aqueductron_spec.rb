require_relative '../lib/aqueductron'

module Aqueductron
  describe Duct do
    describe 'this weird ductline thing' do
      let(:input) { ["one","two","three"]}
      let(:new_builder) { Duct.new() }
      let(:builder) { new_builder }

      subject { builder.answer(Monoid.concat).flow(input).value }

      describe 'giving an answer' do
        let(:input) { ["hello"] }

        it { should == 'hello' }
      end

      describe 'stopping in the middle' do
        let(:builder) { new_builder.take(2) }

        it { should == "onetwo" }
      end

      describe 'filtering' do
        let(:starts_with_t) { ->(s) {s[0] == "t"} }
        let(:builder) { new_builder.keeping(starts_with_t) }

        it { should == "twothree" }
      end

      describe 'mapping' do
        let(:reverse) { ->(a) { a.reverse} }
        let(:builder) { new_builder.through(reverse) }
        it { should == "enoowteerht" }
      end
    end

    describe 'interacting with integers' do
      let(:input) { [1,2,3]}
      let(:new_builder) { Duct.new() }
      let(:builder) { new_builder }

      subject { builder.flow(input).value }

      describe 'adding' do
        let(:builder) { new_builder.answer(Monoid.plus) }
        it { should == 6 }
      end

      describe 'can split the duct' do
        double = ->(a) { a * 2 }
        let(:builder) { new_builder.
          split({ total: Duct.new.answer(Monoid.plus),
                double_the_first: Duct.new.take(1).through(double).answer(Monoid.plus)})
        }
        it 'should have a total of 6'do
          subject.value(:total).should == 6
        end
        it 'should have 2 at the end of the doubling the first duct' do
          subject.value(:double_the_first).should == 2
        end
      end
    end

    describe 'interacting with characters' do
      let(:input) {["one","two"]}
      it 'can widen the duct' do
        array_of_chars = ->(s) {s.each_char}
        is_vowel = ->(c) {"aeiou".include?(c)}
        result = Duct.new.
          expand(array_of_chars).
          keeping(is_vowel).
          answer(Monoid.concat)
        result.flow(input).value.should == "oeo"
      end

      #         /---------------------\
      #        /   :all_concatenated    = concatenated: "onetwo"
      # --------    /-----------------/
      #            <           /------------------------\
      # --------    \         /    :only_first | limit(1) = concatenated: "one"
      #        \     ---------    /---------------------/
      #         \   :all         <
      #          \------------    \-------------------\
      #                       \    :concatenated_again = concatenated: "onetwo"
      #                        \----------------------/
      it 'can nest splits and follow the paths' do
        result = Duct.new.
          split(all_concatenated: Duct.new.answer(Monoid.concat),
                all: Duct.new.
                split(only_first: Duct.new.take(1).answer(Monoid.concat),
                      concatenated_again: Duct.new.answer(Monoid.concat)
                     )
               )
               output = result.flow(input)
               output.value(:all_concatenated).should == "onetwo"
               output.value(:all,:only_first).should == "one"
               output.value(:all,:concatenated_again).should == "onetwo"
      end

      it 'can split immediately after an expansion' do
        array_of_chars = ->(s) {s.each_char}
        is_vowel = ->(c) {"aeiou".include?(c)}
        notnot = ->(p) { ->(a) {!p.call(a)}}
        result = Duct.new().
          expand(array_of_chars).
          split({ vowels: Duct.new.keeping(is_vowel).count,
                consonants: Duct.new.keeping(notnot.(is_vowel)).count
        })
        output = result.flow(["one","two", "three"])
        output.value(:vowels).should == 5
        output.value(:consonants).should == 6
      end
    end
  end
  describe 'partial flows' do
    it 'can accept input in two parts' do
      Duct.new.array.keep_flowing([1,2]).flow([3]).value.should == [1,2,3]
    end
  end
end

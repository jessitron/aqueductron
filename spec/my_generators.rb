require 'generative'

module Generators
  def alpha_char
    all_the_letters = ('a'..'z').to_a + ('A'..'Z').to_a
    all_the_letters.sample
  end

  def int_among(from, to)
    rand(from..to)
  end

  def small_int(to = 10)
    int_among(0, to)
  end

  def array_of(fill_function, length = small_int)
    (1..length).map{ fill_function.call }
  end
end

class GeneratingThing
  include Generators
end

#
# Mario: is there some way to include the generator module
# in my TEST?
#
describe GeneratingThing do
  describe ("characters") do
    generative ("only gives me letters") do
      data(:sample) { subject.alpha_char }

      it("is a letter") do
        (sample =~ /[[:alpha:]]/).should == 0
      end
    end
  end

  describe("integers") do
    generative("numbers in the range") do
      data(:one) { rand(1000) }
      data(:two) { rand(1000) }

      it("returns something in the range") do
        if (one <= two)
          sample = subject.int_among(one, two)
          (sample >= one).should == true
          (sample <= two).should == true
        end
      end
    end
    generative("small integers") do
      # how can I test that it isn't always returning 3?
      data(:sample) { subject.small_int }
      it("is between 0 and 10 by default") do
        (sample >= 0).should == true
        (sample <= 10).should == true
      end
      it("never exceeds the bound, if passed in") do
        new_sample = subject.small_int(sample)
        (new_sample >= 0).should == true
        (new_sample <= sample).should == true
      end
    end
  end

  describe("arrays of something else") do
    #todo: put in oneOf method
    #todo: easy way to get method, with args passed in, as function. Or with args as functions
    generative("builds arrays of letters") do
      data(:length) { subject.small_int }
      let(:fill) { subject.method :alpha_char }
      let(:sample) { subject.array_of(fill, length)}

      it("has the right length") do
        sample.length.should == length
      end
      it ("contains all characters") do
        # is there a forall?
        sample.map { |x| x =~ /^[[:alpha:]]$/ }.each { |b| b.should == 0}
      end
    end

    generative("produces an array of small int length by default") do
      data(:sample) { subject.array_of (subject.method :alpha_char )}
      it("is between 0 and 10 long") do
        (sample.length >= 0).should == true
        (sample.length <= 10).should == true
      end
    end
  end
end

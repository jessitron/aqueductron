require 'generative'

module Generators
  def alphaChar
    allTheLetters = ('a'..'z').to_a + ('A'..'Z').to_a
    allTheLetters.sample
  end

  def intAmong(from, to)
    rand(from..to)
  end

  def smallInt(to = 10)
    intAmong(0, to)
  end

  def arrayOf(fill_function, length = :youPick)
    l = if (length == :youPick) then smallInt else length end
    (1..l).map{ fill_function.call }
  end

end

class GeneratingThing
  include Generators
end

#
# Mario: is there some way to include the generator module
# in my TEST?
#
describe Generators do
  subject = GeneratingThing.new

  describe ("characters") do
    generative ("only gives me letters") do
      data(:sample) { subject.alphaChar }

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
          sample = subject.intAmong(one, two)
          (sample >= one).should == true
          (sample <= two).should == true
        end
      end
    end
    generative("small integers") do
      # how can I test that it isn't always returning 3?
      data(:sample) { subject.smallInt }
      it("is between 0 and 10 by default") do
        (sample >= 0).should == true
        (sample <= 10).should == true
      end
      it("never exceeds the bound, if passed in") do
        newSample = subject.smallInt(sample)
        (newSample >= 0).should == true
        (newSample <= sample).should == true
      end
    end
  end

  describe("arrays of something else") do
    #todo: put in oneOf method
    #todo: easy way to get method, with args passed in, as function. Or with args as functions
    generative("builds arrays of letters") do
      data(:length) { subject.smallInt }
      fill = subject.method :alphaChar
      let(:sample) { subject.arrayOf(fill, length)}

      it("has the right length") do
        sample.length.should == length
      end
      it ("contains all characters") do
        # is there a forall?
        sample.map { |x| x =~ /^[[:alpha:]]$/ }.each { |b| b.should == 0}
      end
    end

    generative("produces an array of small int length by default") do
      data(:sample) { subject.arrayOf (subject.method :alphaChar )}
      it("is between 0 and 10 long") do
        (sample.length >= 0).should == true
        (sample.length <= 10).should == true
      end
    end
  end

end

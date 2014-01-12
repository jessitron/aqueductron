require 'generative'

module Generators
  def alphaChar
    allTheLetters = ('a'..'z').to_a + ('A'..'Z').to_a
    allTheLetters.sample
  end

  def intAmong(from, to)
    rand(from..to)
  end
end

class GeneratingThing
  include Generators
end

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
    generative("numbers in the range")
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

end

require_relative '../lib/aqueductron.rb'
require 'generative'

module Aqueductron
  describe EndPiece do
    let(:subject) { Duct.new.array()}

    # example
    it ("gives me an empty array for empty input")do
      subject.flow([]).value.should == []
    end

    # example
    it ("gives me what I send in an array") do
      subject.flow("jess".chars).value.should == ["j","e","s","s"]
    end

    # Everything Else
    generative ("works for random arrays") do
      data(:input) { Generators.array_of(Generators.method :small_int) }

      it("spits the input back out") do
        subject.flow(input).value.should == input
      end

    end
  end
end

require_relative '../lib/aqueductron.rb'
require_relative 'my_generators'
require 'generative'

module Aqueductron
  gen = GeneratingThing.new
  describe EndPiece do
    let(:subject) { Duct.new.array()}
    it ("gives me an empty array for empty input")do
      subject.flow([]).value.should == []
    end

    it ("gives me what I send in an array") do
      subject.flow("jess".chars).value.should == ["j","e","s","s"]
    end

    generative ("works for random arrays") do
      data(:input) { gen.arrayOf(gen.method :smallInt) }

      it("spits the input back out") do
        subject.flow(input).value.should == input
      end

    end
  end
end

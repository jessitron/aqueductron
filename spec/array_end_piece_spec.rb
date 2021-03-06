require_relative '../lib/aqueductron.rb'

module Aqueductron
  describe EndPiece do
    it ("gives me an empty array for empty input")do
      Duct.new.array().flow([]).value.should == []
    end

    it ("gives me what I send in an array") do
      Duct.new.array().flow("jess".chars).value.should == ["j","e","s","s"]
    end
  end
end

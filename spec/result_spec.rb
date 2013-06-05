require_relative '../lib/aqueductron'

module Aqueductron
  describe Result do
    it 'Simple result doesnt have a hash, so it just gives you the value' do
      SimpleResult.new(4).to_hash.should == 4
    end
    it 'compound result gives an actual hash' do
      CompoundResult.new({ :a => SimpleResult.new(2)}).to_hash.should == { :a => 2}
    end

    it 'simple result drawing' do
      SimpleResult.new("toto").draw.should == ["=> toto"]
      SimpleResult.new([1,2]).draw.should == ["=> [1, 2]"]
    end
    it 'complex result drawing' do
      (CompoundResult.new({ :a => SimpleResult.new(2)}).inspect + "\n").should == <<eos
Result:
 / ---
<   a => 2
 \\ ---
eos

    end
  end

end

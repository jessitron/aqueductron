require_relative '../lib/aqueductron.rb'


# how to say 'all draw methods at all times have the property that the
# string element in each array is the same length' ?
module Aqueductron
  draw_array = ->(a) { a.join("\n") + "\n"}
  describe 'The drawing of the pipe' do
    describe 'An ordinary piece' do
      it 'should print the default description' do
        draw_array.call(Piece.new(LastEndPiece.new,:dummy).draw).should == <<eos
-\\
~ last
-/
eos
      end

    it 'should print a custom description' do
      draw_array.call(Piece.new(CountingEndPiece.new,:dummy,"hello").draw).should == <<eos
-----\\
hello #
-----/
eos
    end
  end

  describe 'drawing an end piece' do
    it 'displays the default symbol' do
      # I'd rather have a herefile but my vi deletes trailing spaces!
      draw_array.call(EndPiece.new(Monoid.plus, :dummy).draw).should == <<eos
\\
 +
/
eos
    end
    #todo: test custom symbol

    it 'displays # for counting' do
      draw_array.call(CountingEndPiece.new.draw).should == <<eos
\\
 #
/
eos
    end
    it 'displays last for last' do
      draw_array.call(LastEndPiece.new.draw).should == <<eos
\\
 last
/
eos

    end
  end

  describe 'drawing a joint piece' do
    it 'has three times as many elements as paths: 1' do
       JointPiece.new({ :this => Duct.new.count}).draw.size.should == 3
    end
    it 'looks right: 1' do
       draw_array.call(JointPiece.new({ :this => Duct.new.count}).draw).should == <<eos
 / ----\\
<  this #
 \\ ----/
eos
      end
    it 'looks right: 2' do
       draw_array.call(JointPiece.new({ :this => Duct.new.array, :that => Duct.new.count}).draw).should == <<eos
   ----\\
 / this []
<  ----/
 \\ ----\\
   that #
   ----/
eos
      end
    # wish this were a property
      it 'has three times as many elements as paths: 2' do
       JointPiece.new({ :this => Duct.new.count, :that => Duct.new.last}).draw.size.should == 6
      end
    end
  end
  describe 'horizontal concatenation' do
    it ('can handle the trivial case of just one') do
      Drawing.horizontal_concat(["blah"],[">"]).should == ["blah>"]
    end
    it ('can concatenate two the same length') do
      Drawing.horizontal_concat(["a","b"],["1","2"]).should == ["a1","b2"]
    end
    it ('can concatenate when the second is smaller') do
      Drawing.horizontal_concat(["a","b"],["1"]).should == ["a1","b"]
    end

    it ('centers the second when the second is smaller') do
      Drawing.horizontal_concat(["a","b","c"],["1"]).should == ["a","b1","c"]
    end
    it ('centers the second when the second is smaller unevenly') do
      Drawing.horizontal_concat(["a","b","c","d"],["1"]).should == ["a","b1","c","d"]
    end
    it ('handles a smaller first') do
      Drawing.horizontal_concat(["a"],["1","2"]).should == ["a1"," 2"]
    end
    it('handles a much smaller first') do
      Drawing.horizontal_concat(["1"],["a","b","c","d"]).should == [" a","1b"," c"," d"]

    end
  end
end

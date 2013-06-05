require_relative '../lib/aqueductron.rb'


# how to say 'all draw methods at all times have the property that the
# string element in each array is the same length' ?
module Aqueductron
  draw_array = ->(a) { a.map { |r| r.rstrip }.join("\n") + "\n"}
  describe 'The drawing of the pipe' do
    describe 'An ordinary piece' do
      it 'should print the default description' do
        draw_array.call(Piece.new(LastEndPiece.new,:dummy).draw).should == <<eos
---\\
 ~  last
---/
eos
      end

    it 'should print a custom description' do
      draw_array.call(Piece.new(CountingEndPiece.new,:dummy,"hello").draw).should == <<eos
-------\\
 hello  #
-------/
eos
    end
  end

  describe 'drawing an end piece' do
    it 'displays the default symbol' do
      draw_array.call(EndPiece.new(Monoid.plus, :dummy).draw).should == <<eos
\\
 +
/
eos
    end
    it 'displays # for counting' do
      draw_array.call(CountingEndPiece.new.draw).should == <<eos
\\
 #
/
eos
    end
    it 'displays # counted so far' do
      draw_array.call(CountingEndPiece.new.drip(".").drip(".").draw).should == <<eos
\\
 # (2)
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
    it 'displays most recent for last, after one has gone' do
      draw_array.call(LastEndPiece.new.keep_flowing(["boo"]).draw).should == <<eos
\\
 last (boo)
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
 / ------\\
<   this  #
 \\ ------/
eos
      end
    it 'looks right: 2' do
       draw_array.call(JointPiece.new({ :this => Duct.new.array, :that => Duct.new.count}).draw).should == <<eos
   ------\\
 /  this  []
<  ------/
 \\ ------\\
    that  #
   ------/
eos
      end
    # wish this were a property
      it 'has three times as many elements as paths: 2' do
       JointPiece.new({ :this => Duct.new.count, :that => Duct.new.last}).draw.size.should == 6
      end
      it 'looks good with keys of different lengths' do
       draw_array.call(JointPiece.new({ :this => Duct.new.count, :those => Duct.new.last}).draw).should == <<eos
   ------\\
 /  this  #
<  ------/
 \\ -------\\
    those  last
   -------/
eos
      end
    end
  end
  describe 'the taking function' do
    it 'counts down' do
      draw_array.call(Duct.new.take(3).last.drip('.').draw).should == <<eos
----------\\
 taking 2  last (.)
----------/
eos
    end
  end

  describe 'the partition piece can draw itself' do
    subject {SpontaneousJointPiece.new({}, ->(a) {a}, ->(a) { Duct.new.count}) }
    it ('can draw an empty partition list') do
      draw_array.call(subject.draw).should == <<eos
 /
<  +?
 \\
eos
    end
    it ('can draw a not-empty partition list') do
      draw_array.call(subject.keep_flowing(["A"]).draw).should == <<eos
 / ---\\
<   A  # (1)
 \\ ---/
   +?
eos
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

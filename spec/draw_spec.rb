require_relative '../lib/aqueductron.rb'

draw_array = ->(a) { a.map { |a| a[1]}.join("\n") + "\n"}

# how to say 'all draw methods at all times have the property that the
# string element in each array is the same length' ?
describe 'The drawing of the pipe' do
  describe 'An ordinary piece' do
    it 'should print the default description' do
      draw_array.call(Aqueductron::Piece.new(:dummy,:dummy).draw).should == <<eos
-
~
-
eos
    end

    it 'should print a custom description' do
      draw_array.call(Aqueductron::Piece.new(:dummy,:dummy,"hello").draw).should == <<eos
-----
hello
-----
eos
    end
  end

  describe 'drawing an end piece' do
    it 'displays the default symbol' do
      # I'd rather have a herefile but my vi deletes trailing spaces!
      draw_array.call(Aqueductron::EndPiece.new(Aqueductron::Monoid.plus, :dummy).draw).should == "\\ \n +\n/ \n"
    end
    #todo: test custom symbol

    it 'displays # for counting' do
      draw_array.call(Aqueductron::CountingEndPiece.new.draw).should == "\\ \n #\n/ \n"
    end
  end

end

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
    it 'displays last for last' do
      draw_array.call(Aqueductron::LastEndPiece.new.draw).should == "\\    \n last\n/    \n"

    end
  end

  describe 'drawing a joint piece' do
    it 'has three times as many elements as paths: 1' do
       Aqueductron::JointPiece.new({ :this => :dummy}).draw.size.should == 3
    end
    it 'looks right: 1' do #TODO: add growy symbol in front
       draw_array.call(Aqueductron::JointPiece.new({ :this => :dummy}).draw).should == <<eos
----
this
----
eos
    end
    # wish this were a property
    it 'has three times as many elements as paths: 2' do
       Aqueductron::JointPiece.new({ :this => :dummy, :that => :dummy}).draw.size.should == 6
    end

    it 'does not try to print stuff on the same lines' do
       Aqueductron::JointPiece.new({ :this => :dummy, :that => :dummy}).draw.map{ |a| a[0]}.uniq.size.should == 6
    end
  end
end

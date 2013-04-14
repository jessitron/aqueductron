require_relative '../../lib/pipeline'

# TODO: create a random sequence generator
input = "AATTGGGGAGCA"

# TODO: put this in a separate file. Flyweight it and use reference equality
class Base
  attr_reader :letter
  def initialize(char)
    @letter = char
  end

  def self.constructor
    ->(atgc) { Base.new(atgc) }
  end

  def self.same(atgc)
    ->(base) { base.letter == atgc}
  end

end

def countLetter(atgc)
  Pipeline::Pipe.new.keeping(Base.same(atgc)).count
end

pipe = Pipeline::Pipe.new.through(Base.constructor).split(
  A: countLetter("A"),
  C: countLetter("C"),
  G: countLetter("G"),
  T: countLetter("T"),
)

result = pipe.flow(input.chars)

a_count = result.value(:A)
c_count = result.value(:C)
g_count = result.value(:G)
t_count = result.value(:T)

puts "A C T G"
puts "#{a_count} #{c_count} #{t_count} #{g_count}"

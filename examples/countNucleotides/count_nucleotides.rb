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

pipe = Pipeline::Pipe.new.through(Base.constructor).split(
  A: Pipeline::Pipe.new.keeping(Base.same("A")).count,
  C: Pipeline::Pipe.new.keeping(Base.same("C")).count
)

result = pipe.flow(input.chars)

a_count = result.value(:A)
c_count = result.value(:C)

puts "#{a_count} #{c_count}"

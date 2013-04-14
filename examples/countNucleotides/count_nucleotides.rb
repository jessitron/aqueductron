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

count_letter = -> (atgc) { Pipeline::Pipe.new.keeping(Base.same(atgc)).count }

bases = "ATGC".chars

pipes = bases.each_with_object({}) {|atgc, hash| hash[atgc] = count_letter.call(atgc) }

pipe = Pipeline::Pipe.new.through(Base.constructor).split(pipes)

result = pipe.flow(input.chars)

puts bases.join(" ")
puts bases.map { |atgc| result.value(atgc)}.join(" ")

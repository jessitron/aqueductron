require_relative '../../lib/aqueductron'

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

count_letter = -> (atgc) { Aqueductron::Duct.new.keeping(Base.same(atgc)).count }

bases = "ATGC".chars

ducts = bases.each_with_object({}) {|atgc, hash| hash[atgc] = count_letter.call(atgc) }

duct = Aqueductron::Duct.new.through(Base.constructor).split(ducts)

result = duct.flow(input.chars)

puts bases.join(" ")
puts bases.map { |atgc| result.value(atgc)}.join(" ")

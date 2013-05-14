require_relative '../../lib/aqueductron'

input = "AATTGGGGAGCAN"

count_letter = ->(unused) { Aqueductron::Duct.new.count }
identity = ->(e) { e }

pipe = Aqueductron::Duct.new.partition(identity, count_letter)

result = duct.flow(input.chars)

bases = result.keys
puts bases.join(" ")
puts bases.map { |atgc| result.value(atgc)}.join(" ")

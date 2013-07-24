
#
# The objective is to count the nucleotides (A,C,T,G) in a string.
#
# ## Simplest solution
# We could construct the pipe ahead of time, with four branches.
require 'aqueductron'

# - Start a new pipe
cn = Duct.new.
# - turn any string passed in into a sequence of chars; each char
# gets passed down individually.
              expand(->(s) {s.each_char}).
# - translate each char into uppercase
              through(->(c) {c.upcase}).
# - split the duct into four pipes. Each filters out only the letter it cares about, and counts them.
              split( {
                 :A => Duct.new.keeping(->(actg) { actg == "A"}).count,
                 :T => Duct.new.keeping(->(actg) { actg == "T"}).count,
                 :C => Duct.new.keeping(->(actg) { actg == "C"}).count,
                 :G => Duct.new.keeping(->(actg) { actg == "A"}).count })

# Now we have a static pipe. To use it, we
# - send in one string
resultingCounts = cn.drip("ACCTAACG").
# - tell it we're done
                     eof

# - get the results
# => 3
resultingCounts.value(:A)
# => 3
resultingCounts.value(:C)
# => 1
resultingCounts.value(:T)
# => 3
resultingCounts.value(:G)

## More General Case
# what if we get some other letter? You're bound to see an N (for no data) in
# any real sequence string.
#
# The more interesting implementation counts
# whatever the heck it gets.
#
puts "This part is more interesting"

# - start the duct
countChars = Duct.new.
# - expand strings into characters, as before
              expand(->(s) {s.each_char}).
# - dynamically divide the data according to a categorization function,
# in this case: uppercase version of the character
              partition(->(a) {a.upcase},
# - for each unique category, a new duct will be created using this function.
                        ->(a) { Duct.new.count })

# Now, we can pass in strings of whatever, and it'll count what it sees.
countChars.drip("AACTGTNNA").eof
#     ---
#      A => 3
#     ---
#     ---
#      C => 1
#     ---
#     ---
#      T => 2
#     ---
#     ---
#      G => 1
#     ---
#     ---
#      N => 2
#     ---

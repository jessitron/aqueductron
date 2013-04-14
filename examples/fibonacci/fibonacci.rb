require_relative '../../lib/pipeline'

# for this problem I need a custom piece.
# It is a piece that provides a function for the next one in terms of the current one
# also, there is always an answer. There's an iteration.
# Then again, in my custom piece, I could choose to provide an answer at any time.
#


integers = -> { (1..Float::INFINITY).lazy }

fib_function = ->(prev_number, prev_prev_number, k = 1) do
  -> (piece,msg) do
    current_val = prev_number + ( prev_prev_number * k )
    #puts("OK, I just got #{prev_number} and am adding it to #{prev_number} * #{k}")
    piece.pass_on(current_val, fib_function.call(current_val, prev_number, k))
  end
end

fib = ->(n, k=1) do
  if n == 1 then
    1
  else
    Pipeline::Pipe.new.custom(fib_function.call(1, 0, k)).take(n-1).last.flow(integers.call).value
  end
end


puts "fib from 1 to 10: "
puts (1..10).map{|n| fib.call(n)}.join(" ")

puts "for n=5, k=3 we have #{fib.call(5,3)}"

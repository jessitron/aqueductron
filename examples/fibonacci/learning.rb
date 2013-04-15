require_relative '../../lib/pipeline'

# for this problem I need a custom piece.
# It is a piece that provides a function for the next one in terms of the current one
# also, there is always an answer. There's an iteration.
# Then again, in my custom piece, I could choose to provide an answer at any time.
#

module Fibonacci
  def rabbits(input, n)
    Pipeline::Pipe.new.custom(empty_fib_function).take(n).last.flow(look_at_this(input)).value
  end

  def look_at_this(rabbits_by_month)
    StuffAndThen.new(rabbits_by_month).lazy
  end

  private
  def estimate_k(first, second, third) #consecutive terms
    (third - second) / first
  end

  def add_data_point(average_so_far, data_points_included, new_data_point)
    (average_so_far * data_points_included + new_data_point) / (data_points_included + 1)
  end

  class StuffAndThen
    def initialize(stuff)
      @stuff = stuff
    end
    include Enumerable
    def each
      @stuff.each do |x|
        yield x
      end
      while true do
        yield :unknown
      end
    end
  end


  def fib_function
    ->(prev_number, prev_prev_number, k = 1, data_points_in_k = 1) do
      ->(piece,msg) do
        if (msg == :unknown)
          current_val = prev_number + ( prev_prev_number * k )
          #puts("OK, I just got #{prev_number} and am adding it to #{prev_number} * #{k}")
          piece.pass_on(current_val, fib_function.call(current_val, prev_number, k))
        else
          this_k = estimate_k(prev_prev_number, prev_number, msg)
          average_k = add_data_point(k, data_points_in_k, this_k)
          piece.pass_on(msg, fib_function.call(msg, prev_number, average_k, data_points_in_k + 1))
        end
      end
    end
  end

  def empty_fib_function
    ->(piece,msg) do
      piece.pass_on(msg, one_data_fib_function.call(msg))
    end
  end

  def one_data_fib_function
    ->(first) do ->(piece,msg) do
        piece.pass_on(msg, two_data_fib_function.call(first, msg))
      end
    end
  end

  def two_data_fib_function
    ->(first,second) do
      ->(piece,msg) do
        k = (msg - second) / first
        piece.pass_on(msg, fib_function.call(msg, second, k, 1))
      end
    end
  end

end

## Example: Fibonacci Rabbits
# based on the problem statement at http://rosalind.info/problems/fib/
#
require 'aqueductron'

# The rabbits, see, they reproduce. Generation n is a function of the
# size of the previous two generations.
#
#    F(n) = F(n - 1) + k * F(n - 2)
#
# The game is to predict future generation sizes.
# Send the known generation sizes down the duct, and it learns
# a value of k. It needs at least 3 generations.
# Send :unknown and the size of the next generation is predicted.
#
### Custom ductwork
# Custom duct pieces contain functions that construct the next
# duct piece out of other functions. Each function knows a little
# more than the one in the previous iteration.
class Fibonacci
  # The duct is short: one custom piece, and then a collector that
  # outputs the last number it has seen. That is the last known value
  # in the sequence of rabbit counts.
  # The interesting parts are the custom function definitions.
  def rabbit_predictor
    Aqueductron::Duct.new.custom(empty_fib_function).last
  end

# First, we know nothing. The initial piece only knows how to accept
# some data and change the piece to incorporate that data.
  def empty_fib_function
    ->(piece,msg) do
      piece.pass_on(msg, one_data_fib_function(msg),"#{msg}..")
    end
  end

# Second, we know one generation's size. That isn't enough to do anything
# except look for the second generation.
  def one_data_fib_function(first)
    ->(piece,msg) do
      piece.pass_on(msg, two_data_fib_function(first, msg),"#{first},#{msg}..")
    end
  end

# Third, we know two generations. Once we get an additional piece of data,
# we can calculate an initial guess at k.
  def two_data_fib_function(first,second)
    ->(piece,msg) do
      k = (msg - second + 0.0) / first # initial guess at k
      piece.pass_on(msg, learning_fib_function(msg, second, k, 1),
                    "..#{second},#{msg}.. starting k~#{k}")
    end
  end

  # Fourth, as long as we keep getting data, we can refine the value of k.
  # Keep using this function, with different arguments, as long as we keep
  # getting observed data points. As long as someone is still counting
  # the rabbits.
  # Once we get :unknown, it's time to start predicting.
  def learning_fib_function(prev_number, prev_prev_number, k, data_points_in_k)
    ->(piece,msg) do
      if (msg == :unknown)
        fib_function(prev_number, prev_prev_number, k).call(piece,msg)
      else
        this_k = estimate_k(prev_prev_number, prev_number, msg)
        average_k = add_data_point(k, data_points_in_k, this_k)
        piece.pass_on(msg, learning_fib_function(msg, prev_number, average_k, data_points_in_k + 1),
                    "..#{prev_number},#{msg}.. learning k~#{average_k}")
      end
    end
  end

  # Fifth and finally, predict future generations based on the value
  # of k we've learned. This one keeps setting up a new version of
  # itself, with different arguments, every time.
  def fib_function(prev_number, prev_prev_number, k)
    ->(piece, _) do # msg is ignored
      current_val = (prev_number + ( prev_prev_number * k )).round
      piece.pass_on(current_val, fib_function(current_val, prev_number, k),
                   "..#{prev_number},#{current_val}.. k=#{k}")
    end
  end

  # helper methods do some calculation
  def estimate_k(first, second, third) #consecutive terms
    (third - second) / first
  end

  def add_data_point(average_so_far, data_points_included, new_data_point)
    (average_so_far * data_points_included + new_data_point) / (data_points_included + 1)
  end
end

### To use this
# get a new prediction duct
rabbits = Fibonacci.new.rabbit_predictor
# Seed it with the known data
seeded = rabbits.keep_flowing([2,5,8,11])
# send :unknown to get the next output
#
#    => 17
#
seeded.drip(:unknown).eof
# and more :unknowns to get subsequent generations
#
#    => 25
#
seeded.drip(:unknown).drip(:unknown)

# for added fun, drip the known generations in one at a time to watch the duct learn.

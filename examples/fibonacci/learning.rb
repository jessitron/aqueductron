require 'aqueductron'

# It is much more interesting to have the population estimate
# based on observed populations.
# This solution calculates a value for k based on the first 3 or
# more generations. More than 3 generations of data leads to a
# refined (averaged) value of k.
module Fibonacci
  # generate an infinite stream of input
  def look_at_this(rabbits_by_month)
    StuffAndThen.new(rabbits_by_month).lazy
  end

  def rabbits(input, n)
    #start with an empty_fib_function, but that will change
    duct = rabbit_predictor
    duct.flow(look_at_this(input).take(n)).value
  end

  def rabbit_predictor
    Aqueductron::Duct.new.custom(empty_fib_function).last
    # for fun in irb:
    # include Fibonacci
    # rabbits = Duct.new.custom(empty_fib_function).split( {
    #           :last => Duct.new.last,
    #           :all  => Duct.new.array })
  end

  private
  # start here: we know nothing
  def empty_fib_function
    ->(piece,msg) do
      piece.pass_on(msg, one_data_fib_function(msg),"#{msg}..")
    end
  end

  # then we know exactly one thing
  def one_data_fib_function(first)
    ->(piece,msg) do
      piece.pass_on(msg, two_data_fib_function(first, msg),"#{first},#{msg}..")
    end
  end

  # then we know exactly two things
  def two_data_fib_function(first,second)
    ->(piece,msg) do
      k = (msg - second + 0.0) / first # initial guess at k
      piece.pass_on(msg, learning_fib_function(msg, second, k, 1),
                    "..#{second},#{msg}.. starting k~#{k}")
    end
  end

  # now, as long as we keep getting data, we can refine the value of k
  # once we get :unknown, we begin predicting
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

  # once we're predicting, we continue predicting. This one keeps
  # returning a new version of itself
  def fib_function(prev_number, prev_prev_number, k)
    ->(piece, _) do # msg is ignored
      current_val = (prev_number + ( prev_prev_number * k )).round
      piece.pass_on(current_val, fib_function(current_val, prev_number, k),
                   "..#{prev_number},#{current_val}.. k=#{k}")
    end
  end

  # helpers
  def estimate_k(first, second, third) #consecutive terms
    (third - second) / first
  end

  def add_data_point(average_so_far, data_points_included, new_data_point)
    (average_so_far * data_points_included + new_data_point) / (data_points_included + 1)
  end

  # an Enumeration of everything we know, followed by an
  # infinite stream of :unknown
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


end

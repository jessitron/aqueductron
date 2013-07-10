module Aqueductron
  #
  # a Monoid combines two things. This is good for
  # summarizing at the end of a duct.
  # Because it combines, the monoid has an "append" operation
  # that is conceptually a lot like "add."
  # but it doesn't have to be ordinary
  # add. It could multiply. It could append. It could choose the
  # biggest one. Any sort of summary operation that takes two of
  # something and returns just one of the same kind of thing.
  #
  # This would like to have a type parameter T. Let's
  # pretend it does.
  class Monoid
    attr_reader :zero, :symbol
    # zero: an instance of T that I can add to any other T
    #       as many times as I want, and I'll always get the
    #       other T back. Like 0 in integer addition.
    # add_lambda: the append function. this is a function of
    #       two Ts that returns a T. (T,T) => T
    # symbol: for the ascii art. Defaults to "+"
    def initialize(zero, add_lambda, symbol = "+")
      @zero = zero
      @append = add_lambda
      @symbol = symbol
    end
    #
    # put two objects of type T into one object of type T
    def append(a,b)
      @append.call(a,b)
    end

    # instances. These are handy.

    # string concatenation monoid
    def self.concat
      Monoid.new("", ->(a,b) {a + b})
    end
    # integer summation monoid
    def self.plus
      Monoid.new(0,  ->(a,b) {a + b})
    end
  end
end

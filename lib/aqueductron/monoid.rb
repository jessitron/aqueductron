module Aqueductron
  class Monoid
    attr_reader :zero, :symbol
    def initialize(zero, add_lambda, symbol = "+")
      @zero = zero
      @append = add_lambda
      @symbol = symbol
    end
    def append(a,b)
      @append.call(a,b)
    end

    # instances
    def self.concat
      Monoid.new("", ->(a,b) {a + b})
    end
    def self.plus
      Monoid.new(0,  ->(a,b) {a + b})
    end
  end
end

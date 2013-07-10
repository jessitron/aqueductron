require_relative 'result'

module Aqueductron
  #
  # A Result that holds one value
  class SimpleResult
    include Result
    def initialize(value)
      @value = value
    end

    # no further traversal
    def keys
      []
    end

    def value
      @value
    end

    def to_hash
      @value
    end

    def draw
      [ "=> #{@value}"]
    end
  end
end

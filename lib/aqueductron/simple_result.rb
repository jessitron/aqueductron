require_relative 'result'

module Aqueductron
  class SimpleResult
    include Result
    def initialize(value)
      @value = value
    end

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

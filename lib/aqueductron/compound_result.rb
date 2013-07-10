module Aqueductron
  #
  # this Result holds multiple results in
  # a dictionary sort of structure.
  class CompoundResult
    include Result
    #
    # paths: a hash of keys (symbols) to more results
    def initialize(paths)
      @contents = paths
    end

    def keys
      @contents.keys
    end

    #
    # traverse a symbol path to get the result at the end
    # of the duct described by that path
    # path: array of symbols that describe a route down the duct
    def value(*path)
      return self if path.empty?
      (head, *tail) = path
      puts "Nothing found at #{head}" unless @contents[head]
      @contents[head].value(*tail)
    end

    def to_hash
      @contents.map_values {|a| a.to_hash}
    end

    def draw
      paths = Drawing.draw_multiple_paths(@contents)
      Drawing.horizontal_concat(Drawing.joint_prefix, paths)
    end
  end
end

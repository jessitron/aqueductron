module Aqueductron
  class CompoundResult
    include Result
    def initialize(paths)
      @contents = paths
    end

    def keys
      @contents.keys
    end

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

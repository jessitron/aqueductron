
require_relative 'compound_result'
require_relative 'piece_common'

module Aqueductron
  class SpontaneousJointPiece
    attr_reader(:paths, :categorize, :make_new_path) # TODO: make private
    def initialize(paths, categorize, make_new_path)
      @categorize = categorize
      @make_new_path = make_new_path
      @paths = paths
    end
    include PieceCommon

    def receive(msg)
      category = categorize.call(msg)
      new_map = if (paths.key? category)
        paths
      else
        new_paths = paths.dup
        new_paths[category] = make_new_path.call(category)
        new_paths
      end
      go = ->(v) { v.result? ? v : v.receive(msg) }
      new_map[category] = go.call(new_map[category]) #todo: don't mutate
      if (new_map.values.all? &:result? )
        construct_compound_result(new_map)
      else
        SpontaneousJointPiece.new(new_map, categorize, make_new_path)
      end
    end

    def eof
      go = ->(v) { v.result? ? v : v.eof }
      new_map = paths.map_values(&go)
      construct_compound_result(new_map)
    end

    def draw
      ducts = Drawing.draw_multiple_paths(@paths)
      paths = (ducts + ["+?"]).flatten
      Drawing.horizontal_concat(Drawing.joint_prefix, paths)
    end

    private
    def construct_compound_result(paths)
      CompoundResult.new(paths)
    end
  end
end

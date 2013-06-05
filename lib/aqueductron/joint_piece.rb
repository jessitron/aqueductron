require_relative 'compound_result'
require_relative 'piece_common'
require_relative 'drawing'

module Aqueductron
  class JointPiece
    def initialize(paths)
      @paths = paths
    end
    include PieceCommon

    def receive(msg)
      go = ->(v) { v.result? ? v : v.receive(msg) }
      new_map = @paths.map_values(&go)
      if (new_map.values.all? &:result? )
        construct_compound_result(new_map)
      else
        JointPiece.new(new_map)
      end
    end

    def eof
      go = ->(v) { v.result? ? v : v.eof }
      new_map = @paths.map_values(&go)
      construct_compound_result(new_map)
    end


    def draw
      @paths.keys.map{ |k| Drawing.draw_mid_piece(k.to_s)}.flatten(1)
    end
    private
    def construct_compound_result(paths)
      CompoundResult.new(paths)
    end
  end
end

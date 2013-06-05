require_relative 'compound_result'
require_relative 'piece_common'
require_relative 'mid_piece_drawing'

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
      desc = @paths.keys[0].to_s
      dashes = "-" * desc.length
      [[-1, "/ " + dashes],
       [ 0, "  " + desc],
       [ 1, "\ " + dashes]]
      @paths.keys.map{ |k| MidPieceDrawing.draw(k.to_s)}.flatten(1)
    end
    private
    def construct_compound_result(paths)
      CompoundResult.new(paths)
    end
  end
end

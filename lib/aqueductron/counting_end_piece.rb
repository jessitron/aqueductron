require_relative 'piece_common'
require_relative 'drawing'

module Aqueductron
  class CountingEndPiece
    include PieceCommon
    def initialize(so_far = 0)
      @so_far = so_far
    end
    def eof
      SimpleResult.new(@so_far)
    end
    def receive msg
      CountingEndPiece.new(@so_far + 1)
    end

    def draw
      Drawing.draw_end_piece("#")
    end

  end
end

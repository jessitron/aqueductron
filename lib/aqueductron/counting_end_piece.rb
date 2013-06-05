require_relative 'piece_common'
require_relative 'end_piece_drawing'

module Aqueductron
  class CountingEndPiece
    include PieceCommon
    include EndPieceDrawing
    def initialize(so_far = 0)
      @so_far = so_far
      @symbol = "#"
    end
    def eof
      SimpleResult.new(@so_far)
    end
    def receive msg
      CountingEndPiece.new(@so_far + 1)
    end

  end
end

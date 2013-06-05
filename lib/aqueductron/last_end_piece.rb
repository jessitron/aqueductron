require_relative 'piece_common'
require_relative 'end_piece_drawing'

module Aqueductron
  class LastEndPiece
    include PieceCommon
    include EndPieceDrawing
    def initialize(most_recent = :no_data)
      @most_recent = most_recent
      @symbol = "last"
    end
    def eof
      SimpleResult.new(@most_recent)
    end
    def receive msg
      LastEndPiece.new(msg)
    end
  end
end

require_relative 'piece_common'
require_relative 'simple_result'
require_relative 'end_piece_drawing'

module Aqueductron
  class EndPiece
    include PieceCommon
    include EndPieceDrawing

    def initialize(monoid, so_far = :no_value)
      @monoid = monoid
      @so_far = (so_far == :no_value) ? monoid.zero : so_far
      @symbol = monoid.symbol
    end

    def eof
      SimpleResult.new(@so_far)
    end

    def receive msg
      EndPiece.new(@monoid, @monoid.append(@so_far, msg))
    end
  end
end

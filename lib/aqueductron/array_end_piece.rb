require_relative 'piece_common'
require_relative 'drawing'

module Aqueductron
  class ArrayEndPiece
    include PieceCommon
    def initialize(so_far = [])
      @so_far = so_far
    end
    def eof
      SimpleResult.new(@so_far)
    end
    def receive msg
      ArrayEndPiece.new(@so_far + [msg])
    end

    def draw
      desc = @so_far.empty? ? "[]" : "[] (#{@so_far})"
      Drawing.draw_end_piece(desc)
    end

  end
end

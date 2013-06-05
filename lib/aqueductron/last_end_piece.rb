require_relative 'piece_common'
require_relative 'drawing'

module Aqueductron
  class LastEndPiece
    include PieceCommon
    def initialize(most_recent = :no_data)
      @most_recent = most_recent
    end
    def eof
      SimpleResult.new(@most_recent)
    end
    def receive msg
      LastEndPiece.new(msg)
    end
    def draw
      desc = (@most_recent == :no_data)? "last" : "last (#{@most_recent})"
      Drawing.draw_end_piece(desc)
    end
  end
end

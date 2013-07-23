require_relative 'piece_common'
require_relative 'simple_result'
require_relative 'drawing'

module Aqueductron
  class EndPiece
    include PieceCommon
    def initialize(monoid, so_far = :no_value)
      @monoid = monoid
      @so_far = (so_far == :no_value) ? monoid.zero : so_far
    end

    def finish
      SimpleResult.new(@so_far)
    end

    def receive msg
      EndPiece.new(@monoid, @monoid.append(@so_far, msg))
    end

    def draw
      Drawing.draw_end_piece(@monoid.symbol)
    end
  end
end

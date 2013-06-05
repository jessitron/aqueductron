require_relative 'piece_common'
require_relative 'drawing'

module Aqueductron
  class Piece
    attr_reader :destination
    include PieceCommon

    def draw
      desc = " " + @description + " "
      Drawing.horizontal_concat(Drawing.draw_mid_piece(desc),@destination.draw)
    end

    def initialize(destination, what_to_do, description = "~")
      @destination = destination
      @what_to_do = what_to_do
      @description = description
    end

    def receive(msg)
      @what_to_do.call(self, msg)
    end

    def eof
      send_eof
    end

    def pass_on(msg, what_to_do_next, description = "~")
      next_destination = @destination.receive(msg)
      if (next_destination.result?) then
        next_destination # not a destination at all; result
      else
        Piece.new(next_destination, what_to_do_next, description)
      end
    end
    def send_eof
      @destination.eof
    end
  end
end

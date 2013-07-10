require_relative 'piece_common'
require_relative 'drawing'

module Aqueductron
  class Piece
    attr_reader :destination
    include PieceCommon

    #
    # ascii art. return an array of strings, which when
    # printed each on one line, represent
    # the duct, including this piece and all following
    # pieces.
    def draw
      desc = " " + @description + " "
      Drawing.horizontal_concat(Drawing.draw_mid_piece(desc),@destination.draw)
    end

    #
    # destination: the next piece in the duct
    # what_to_do: a function of (piece, message) that returns
    #  the next version of this piece.
    def initialize(destination, what_to_do, description = "~")
      @destination = destination
      @what_to_do = what_to_do
      @description = description
    end

    #
    # receive a message. Returns either a Result or a Piece.
    # The Result means we're done; the Piece is ready to
    # receive the next message (or EOF)
    def receive(msg)
      @what_to_do.call(self, msg)
    end

    #
    # when there are no more messages, and it's time to
    # take what we have and scrape together a Result.
    # Always returns a Result.
    def eof
      send_eof
    end

    #
    # Send a message on to the next piece in the duct.
    # If that one returns a result, return that to my caller;
    # otherwise, it returned a new destination Piece, so
    # I return a new version of myself, with that new destination
    # and the supplied what_to_do function.
    # msg = what to say to the destination piece
    # what_to_do_next = a function of (piece, message) that returns
    #   either a result or a new piece
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

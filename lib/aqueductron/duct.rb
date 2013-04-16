require_relative 'buildering'

module Aqueductron
  class Duct
    include Buildering
    def initialize(things_so_far = [])
      @do_these_things = things_so_far
    end

    def attach(piece)
      Duct.new(@do_these_things + [piece])
    end

    def answer_int(piece)
      if (@do_these_things.empty?)
        piece
      else
        answer_int(Piece.new(piece, @do_these_things.pop))
      end
    end
  end
end

require_relative 'counting_end_piece'
require_relative 'last_end_piece'
require_relative 'end_piece'
require_relative 'inlet'
require_relative 'joint_piece'
require_relative 'piece'
require_relative 'partition'
require_relative 'array_end_piece'

module Aqueductron
  module Buildering
    def answer(monoid)
      answer_int(EndPiece.new(monoid))
    end

    def count
      answer_int(CountingEndPiece.new)
    end

    def array
      answer_int(ArrayEndPiece.new)
    end

    def take(how_many)
      attach(take_function(how_many))
    end

    def keeping(predicate)
      attach(filter_function(predicate))
    end

    def through(transform)
      attach(map_function(transform))
    end

    def custom(piece)
       attach(piece)
    end

    def expand(transform)
      attach(expand_function(transform))
    end

    def split(paths)
      answer_int(JointPiece.new(paths))
    end

    def partition(categorize, make_new_path)
      answer_int(SpontaneousJointPiece.new({}, categorize, make_new_path))
    end

    def last
      answer_int(LastEndPiece.new)
    end

    module_function
    def take_function(how_many) # this will either return a Result or a Piece
      what_to_do = ->(piece, msg) do
        if (how_many == 0) then # this is a little inefficient. One extra piece of info will be read
          piece.send_eof
        else
          how_many_more = how_many - 1
          piece.pass_on(msg, take_function(how_many_more), "taking #{how_many_more}")
        end
      end
    end

    def expand_function(expansion)
      ->(piece, msg) do
        next_piece = Inlet.flow(piece.destination, expansion.call(msg))
        Piece.new(next_piece, expand_function(expansion))
      end
    end

    def map_function(transform)
      ->(piece, msg) do
        piece.pass_on(transform.call(msg), map_function(transform))
      end
    end

    def filter_function(predicate)
      ->(piece, msg) do
        if(predicate.call(msg)) then
          piece.pass_on(msg, filter_function(predicate))
        else
          piece #don't change
        end
      end
    end

  end
end

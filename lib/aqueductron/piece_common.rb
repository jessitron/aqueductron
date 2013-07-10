module Aqueductron
  module PieceCommon
    #
    # send myself each message and then EOF.
    # Always returns a Result
    # source: an Enumerable of messages
    def flow(source)
      Inlet.flow(self, source.each).eof
    end

    #
    # send myself each message. Returns
    # either a Result or a Piece
    # source: an Enumerable of messages
    def keep_flowing(source)
      Inlet.flow(self, source.each)
    end

    #
    # send one message
    # returns either a Result or a Piece
    def drip(one_thing)
      keep_flowing([one_thing])
    end

    def result?
      false
    end

    def inspect
      "Duct:\n" + draw.join("\n")
    end
  end
end

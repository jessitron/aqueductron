module Aqueductron
  class Inlet
    def initialize(next_piece, done_or_not = :done)
      @next_piece = next_piece
      @done_or_not = done_or_not
    end

    def flow(source)
      flow_internal(source.each)
    end

    def flow_internal(source, send_eof = true)
      result = begin
                 response = @next_piece.receive(source.next)
                 if (response.result?) then
                   response
                 else #it's another piece
                   Inlet.new(response, @done_or_not).flow_internal(source, send_eof)
                 end
               rescue StopIteration
                 if (@done_or_not == :done && send_eof) then
                   @next_piece.eof
                 else
                   @next_piece
                 end
               end
    end
  end
end


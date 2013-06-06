module Aqueductron
  class Inlet
    def self.flow(piece, messages)
      begin
        response = piece.receive(messages.next)
        if (response.result?) then
          response
        else #it's another piece
          flow(response, messages)
        end
      rescue StopIteration
          piece
      end
     end
  end
end


module Aqueductron
  module MidPieceDrawing
    def self.draw(description)
      dashes = "-" * description.length
      [[-1, dashes],
       [ 0, description],
       [ 1, dashes]]
    end
  end
end

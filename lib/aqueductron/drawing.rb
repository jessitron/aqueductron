module Aqueductron
  module Drawing
    def self.draw_mid_piece(description)
      dashes = "-" * description.length
      [dashes, description, dashes]
    end
    def self.draw_end_piece(symbol)
      spaces = " " * symbol.length
      ["\\" + spaces, " #{symbol}", "/" + spaces ]
    end
  end
end

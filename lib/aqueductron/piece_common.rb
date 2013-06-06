module Aqueductron
  module PieceCommon
    def flow(source)
      Inlet.flow(self, source.each).eof
    end

    def keep_flowing(source)
      Inlet.flow(self, source.each)
    end

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

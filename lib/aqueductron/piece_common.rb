module Aqueductron
  module PieceCommon
    def flow(source)
      Inlet.new(self).flow_internal(source.each)
    end
    def keep_flowing(source)
      Inlet.new(self).flow_internal(source.each, false)
    end
    def result?
      false
    end
    def inspect
      "Duct:\n" + draw.join("\n")
    end
  end
end

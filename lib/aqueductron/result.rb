module Aqueductron
  module Result
    def result?
      true
    end
    def inspect
      "\n" + draw.join("\n")
    end
  end
end

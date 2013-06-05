module Aqueductron
  module Result
    def result?
      true
    end
    def inspect
      "Result:\n" + draw.join("\n")
    end
  end
end

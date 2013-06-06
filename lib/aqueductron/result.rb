module Aqueductron
  module Result
    def result?
      true
    end
    def inspect
      "Result:\n" + draw.join("\n")
    end
    def eof
      self
    end
    def receive(msg)
      self
    end
  end
end

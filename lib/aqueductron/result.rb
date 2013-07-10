module Aqueductron
  module Result
    # Yes. Yes, I'm done
    def result?
      true
    end
    def inspect
      "Result:\n" + draw.join("\n")
    end
    # act like a piece that does nothing new
    def eof
      self
    end
    # act like a piece that does nothing new
    def receive(msg)
      self
    end
  end
end

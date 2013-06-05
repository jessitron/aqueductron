module Aqueductron
  module Drawing
    def self.draw_mid_piece(description)
      dashes = "-" * description.length
      [dashes, description, dashes]
    end
    def self.draw_end_piece(symbol)
      ["\\", " #{symbol}", "/"]
    end
    def self.joint_prefix
       [" / ","<  ", ' \\ ']
    end

    def self.horizontal_concat(first, second)
      # I <3 Ruby. this kind of recursive ref doesn't work in Scala
      identity = ->(piece,msg) { piece.pass_on(msg, identity)}
      concat_one_of_these= ->(array) {
        ->(piece,msg) {
           (head, *tail) = array
           if (tail.empty?)
             piece.pass_on(msg + head, identity)
           else
             piece.pass_on(msg + head, concat_one_of_these.call(tail))
           end
        }
      }
      centeredSecond = centered_on(first.length, second)
      centered_first = centered_on(second.length, first, padding(first), padding(first))
      duct = Duct.new.custom(concat_one_of_these.call(centeredSecond)).array()
      duct.flow(centered_first).value
    end

    private
    def self.centered_on(length, array, paddingBefore = "", paddingAfter = "")
      if (length <= array.length)
        array
      else
        top_spacing = (length - array.length) / 2
        bottom_spacing = ((length - array.length) / 2.0).ceil
        ([paddingBefore] * top_spacing) + array + ([paddingAfter] * bottom_spacing)
      end
    end

    def self.padding(array)
      " " * array.first.length
    end
  end
end

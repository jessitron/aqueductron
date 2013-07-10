
class Hash
  #
  # apply a function to every value in the hash, returning
  # a new hash containing the same keys, each mapped to the
  # result of applying the supplied function to the value in
  # this hash
  def map_values &block
    self.each_with_object({}) {|(k,v), h| h[k] = block.call(v) }
  end
end

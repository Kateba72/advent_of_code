module StringMixins
  def integers
    self.scan(/\d+/).map(&:to_i)
  end
  alias_method :ints, :integers
end

class String
  prepend StringMixins
end

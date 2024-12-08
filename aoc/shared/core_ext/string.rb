module StringMixins
  def integers
    scan(/\d+/).map(&:to_i)
  end
  alias ints integers
end

class String
  prepend StringMixins
end

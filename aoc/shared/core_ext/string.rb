module StringMixins
  def integers(negative: false)
    if negative
      scan(/-?\d+/).map(&:to_i)
    else
      scan(/\d+/).map(&:to_i)
    end
  end
  alias ints integers
end

class String
  prepend StringMixins
end

module RangeMixins
  def intersection(other)
    return 0...0 unless max && other.max # Ensure both ranges are not empty
    return 0...0 if max < other.min || other.max < min

    [min, other.min].max..[max, other.max].min
  end
  alias & intersection

  def union(other)
    return self unless other.max
    return other unless max # Deal with empty ranges
    raise 'Union of disjunct ranges' if max.succ < other.min || other.max.succ < min

    [min, other.min].min..[max, other.max].max
  end
  alias | union

  def reverse
    r = dup
    def r.each(&)
      last.downto(first, &)
    end
    r
  end
end

module RangeClassMixins
  def reversible(x, y, exclude_end: false)
    if x < y
      new(x, y, exclude_end)
    else
      new(y, x, exclude_end).reverse
    end
  end
end

Range.prepend RangeMixins
Range.singleton_class.prepend RangeClassMixins

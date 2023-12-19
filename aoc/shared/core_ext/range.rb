module RangeMixins
  def intersection(other)
    return 0...0 unless self.max && other.max # Ensure both ranges are not empty
    return 0...0 if self.max < other.min || other.max < self.min
    [self.min, other.min].max .. [self.max, other.max].min
  end
  alias_method :&, :intersection

  def union(other)
    return self unless other.max
    return other unless self.max # Deal with empty ranges
    raise "Union of disjunct ranges" if self.max.succ < other.min || other.max.succ < self.min
    [self.min, other.min].min .. [self.max, other.max].max
  end
  alias_method :|, :union
end

class Range
  prepend RangeMixins
end

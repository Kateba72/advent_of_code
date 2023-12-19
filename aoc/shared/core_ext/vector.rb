module VectorMixins
  def p_norm_to_p(v, p)
    raise ExceptionForMatrix::ErrDimensionMismatch if size != v.size

    d = 0
    each2(v) do |v1, v2|
      d += (v1 - v2).abs ** p
    end
    d
  end

  def manhattan(v)
    raise ExceptionForMatrix::ErrDimensionMismatch if size != v.size

    d = 0
    each2(v) do |v1, v2|
      d += (v1 - v2).abs
    end
    d
  end
end

class Vector
  prepend VectorMixins
end

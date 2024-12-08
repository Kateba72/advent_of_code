module VectorMixins
  def p_norm_to_p(v, p) # rubocop:disable Naming/MethodParameterName
    raise ExceptionForMatrix::ErrDimensionMismatch if size != v.size

    d = 0
    each2(v) do |v1, v2|
      d += (v1 - v2).abs**p
    end
    d
  end

  def manhattan(v) # rubocop:disable Naming/MethodParameterName
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

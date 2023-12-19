module ArrayMixins
  def neighbors(x, y, include_diagonal=false)
    a = [
      x > 0 ? self[x-1][y] : nil,
      y > 0 ? self[x][y-1] : nil,
      self[x+1]&.at(y),
      self[x][y+1],
    ]

    if include_diagonal
      a << self[x-1][y-1] if x > 0 && y > 0
      a << self[x-1][y+1] if x > 0
      a << self[x+1]&.at(y-1) if y > 0
      a << self[x+1]&.at(y+1)
    end

    a.compact
  end

  def neighbors_with_indexes(x, y, include_diagonal: false, include_self: false)
    indexes = [
      [x-1, y],
      [x, y-1],
      [x+1, y],
      [x, y+1]
    ]

    if include_diagonal
      indexes << [x-1, y-1]
      indexes << [x-1, y+1]
      indexes << [x+1, y-1]
      indexes << [x+1, y+1]
    end

    indexes << [x, y] if include_self

    indexes.map do |nx, ny|
      next unless nx >= 0 && ny >= 0
      value = [self[nx]&.at(ny), nx, ny]
      next unless value[0]
      value
    end.compact
  end
end

class Array
  prepend ArrayMixins
end

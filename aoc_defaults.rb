require 'net/http'
require 'active_support'
require 'active_support/core_ext'
require 'byebug'
require 'memoized'

def get_aoc_input(year, day)
  filename = File.join(File.dirname(__FILE__), "#{year}/input-#{day}.txt")

  if File.exists?(filename)
    File.read(filename)
  else
    cookie = File.read(File.join(File.dirname(__FILE__), 'cookie.txt'))
    uri = URI.parse("https://adventofcode.com/#{year}/day/#{day}/input")
    resp = Net::HTTP.get(uri, { 'Cookie' => cookie, 'User-Agent' => 'kateba@posteo.de (github.com/Kateba72/advent_of_code)' })
    File.write(filename, resp)
    resp
  end
end

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

  def neighbors_with_indexes(x, y, include_diagonal=false)
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
    raise "Union of disjunct ranges" if self.max < other.min - 1 || other.max < self.min - 1
    [self.min, other.min].min .. [self.max, other.max].max
  end
  alias_method :|, :union
end

class Range
  prepend RangeMixins
end

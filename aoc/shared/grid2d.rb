require 'matrix'
require 'forwardable'
require 'memoized'

class Grid2d
  include Enumerable
  extend Forwardable
  include Memoized

  OutOfBoundsError = Class.new(IndexError)

  def_delegators :@grid, :size, :[], :each

  attr_reader :height, :width, :grid

  DIRECTIONS = {
    1 => Vector[0, -1],
    2 => Vector[-1, 0],
    3 => Vector[1, 0],
    4 => Vector[0, 1],
  }

  NEIGHBORS = [
    Vector[-1, 0],
    Vector[0, -1],
    Vector[0, 1],
    Vector[1, 0],
  ]

  NEIGHBORS_WITH_DIAGONALS = [
    Vector[-1, -1],
    Vector[-1, 0],
    Vector[-1, 1],
    Vector[0, -1],
    Vector[0, 1],
    Vector[1, -1],
    Vector[1, 0],
    Vector[1, 1],
  ]

  def initialize(grid, height: nil, width: nil)
    @grid = grid
    @height = height || grid.size
    @width = width || grid[0].size
  end

  def at(vector, default = nil)
    return default unless in_bounds?(vector)
    @grid[vector[1]][vector[0]]
  end

  def at!(vector)
    raise OutOfBoundsError unless in_bounds?(vector)
    @grid[vector[1]][vector[0]]
  end

  def set_at(vector, value)
    raise OutOfBoundsError unless in_bounds?(vector)
    @grid[vector[1]][vector[0]] = value
  end

  def in_bounds?(vector)
    vector[0] >= 0 && vector[0] < width && vector[1] >= 0 && vector[1] < height
  end

  def corners
    [Vector[0, 0], Vector[0, height - 1], Vector[width - 1, height - 1], Vector[width - 1, 0]]
  end

  def edges
    Enumerator.new(height * 2 + width * 2) do |y|
      (0...height).each do |i|
        y << [Vector[0, i], 3]
        y << [Vector[width - 1, i], 2]
      end
      (0...width).each do |i|
        y << [Vector[i, 0], 4]
        y << [Vector[i, height - 1], 1]
      end
    end
  end

  def row(y)
    @grid[y]
  end

  memoize def column(x)
    @grid.map { |row| row[x] }
  end

  def with_coords
    Enumerator.new(width * height) do |enum|
      @grid.each_with_index do |line, y|
        line.each_with_index do |elem, x|
          enum << [elem, Vector[x, y]]
        end
      end
    end
  end

  def rot90_ccw
    columns = (0...width).map { |i| column(i) }
    Grid2d.new(columns.reverse, height: width, width: height)
  end

  def rot90_cw
    reversed_columns = (0...width).map do |i|
      column(i).reverse
    end
    Grid2d.new(reversed_columns, height: width, width: height)
  end

  def rot180
    Grid2d.new(grid.reverse.map(&:reverse), height:, width:)
  end

  def flip_vertical
    Grid2d.new(grid.reverse, height:, width:)
  end

  def flip_horizontal
    Grid2d.new(grid.map(&:reverse), height:, width:)
  end

  def add_border(element, border_width: 1, border_height: nil)
    border_height ||= border_width
    padding_rows = Array.new(border_height) { [element] * (2 * border_width + width) }
    new_grid = padding_rows + @grid.map do |row|
      [element] * border_width + row + [element] * border_width
    end + padding_rows.deep_dup
    Grid2d.new(new_grid, width: width + 2 * border_width, height: height + 2 * border_height)
  end
end

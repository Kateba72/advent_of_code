require 'matrix'
require 'forwardable'

class Grid2d
  include Enumerable
  extend Forwardable

  OutOfBoundsError = Class.new(IndexError)

  def_delegators :@grid, :size, :[], :each

  attr_reader :height, :width, :grid

  DIRECTIONS = {
    1 => Vector[0, -1],
    2 => Vector[-1, 0],
    3 => Vector[1, 0],
    4 => Vector[0, 1],
  }

  def initialize(grid, height: nil, width: nil)
    @grid = grid
    @height = height || grid.size
    @width = width || grid[0].size
  end

  def at(vector)
    raise OutOfBoundsError unless in_bounds?(vector)
    @grid[vector[1]][vector[0]]
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

  def rot90_ccw
    columns = (0...width).map do |i|
      @grid.map { |row| row[i] }
    end.reverse
    Grid2d.new(columns, height: width, width: height)
  end

  def rot90_cw
    columns = (0...width).map do |i|
      @grid.map { |row| row[i] }.reverse
    end
    Grid2d.new(columns, height: width, width: height)
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
end

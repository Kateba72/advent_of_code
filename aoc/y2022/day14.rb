require_relative '../aoc_defaults'
require 'matrix'

class Day14
  include Memoized

  def part1
    map, offset, maximum = draw_lines.deep_dup

    source = Vector[500, 0] - offset

    (0..).each do |i|
      grain_position = source
      break i if loop do
        if grain_position[1] >= maximum[1]
          break true
        elsif map[*(grain_position + Vector[0, 1])] == 0
          grain_position += Vector[0, 1]
        elsif map[*(grain_position + Vector[-1, 1])] == 0
          grain_position += Vector[-1, 1]
        elsif map[*(grain_position + Vector[1, 1])] == 0
          grain_position += Vector[1, 1]
        else
          break false
        end
      end
      map[*grain_position] = 2
    end
  end

  def part2
    map, offset, maximum = draw_lines.deep_dup
    (0..maximum[0]).each do |x|
      map[x, maximum[1]] = 1
    end

    source = Vector[500, 0] - offset

    (0..).each do |i|
      grain_position = source
      loop do
        if map[*(grain_position + Vector[0, 1])] == 0
          grain_position += Vector[0, 1]
        elsif map[*(grain_position + Vector[-1, 1])] == 0
          grain_position += Vector[-1, 1]
        elsif map[*(grain_position + Vector[1, 1])] == 0
          grain_position += Vector[1, 1]
        else
          break
        end
      end
      break i + 1 if grain_position == source
      map[*grain_position] = 2
    end
  end

  def print_map(map)
    puts map.transpose.to_a.map { |l| l.join(' ') }.join "\n"
    puts
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def draw_lines
    input = get_input
    dimensions = [[500, 500], [0, 0]]
    input.each do |line|
      line.each do |entry|
        dimensions[0][0] = dimensions[0][0] < entry[0] ? dimensions[0][0] : entry[0]
        dimensions[0][1] = dimensions[0][1] > entry[0] ? dimensions[0][1] : entry[0]
        dimensions[1][0] = dimensions[1][0] < entry[1] ? dimensions[1][0] : entry[1]
        dimensions[1][1] = dimensions[1][1] > entry[1] ? dimensions[1][1] : entry[1]
      end
    end

    dimensions[1][1] += 2
    dimensions[0][0] = dimensions[0][0] < 500 - dimensions[1][1] - 1 ? dimensions[0][0] : 500 - dimensions[1][1] - 1
    dimensions[0][1] = dimensions[0][1] > 500 + dimensions[1][1] + 1 ? dimensions[0][1] : 500 + dimensions[1][1] + 1

    offset = Vector[dimensions[0][0], dimensions[1][0]]
    maximum = Vector[dimensions[0][1], dimensions[1][1]] - offset

    map = Matrix.zero(maximum[0] + 1, maximum[1] + 1)

    input.each do |line|
      line[1..].zip(line).each do |start, ending|
        start -= offset
        ending -= offset
        if start[0] == ending[0]
          a, b = start[1] < ending[1] ? [start[1], ending[1]] : [ending[1], start[1]]
          (a..b).each { |y| map[start[0], y] = 1 }
        else
          a, b = start[0] < ending[0] ? [start[0], ending[0]] : [ending[0], start[0]]
          (a..b).each { |x| map[x, start[1]] = 1 }
        end
      end
    end

    [map, offset, maximum]
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 14)
    end.split("\n").map do |line|
      line.split(' -> ').map do |entry|
        Vector[*entry.split(',').map { |coordinate| coordinate.to_i }]
      end
    end
  end

  def get_test_input(number)
    <<~TEST
      498,4 -> 498,6 -> 496,6
      503,4 -> 502,4 -> 502,9 -> 494,9
    TEST
  end
end

if __FILE__ == $0
  today = Day14.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

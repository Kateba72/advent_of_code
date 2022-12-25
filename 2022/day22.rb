require_relative '../aoc_defaults'
require 'benchmark'
require 'matrix'

UP = Vector[0, -1]
RIGHT = Vector[1, 0]
DOWN = Vector[0, 1]
LEFT = Vector[-1, 0]

REVERSE_OFFSET = {
  RIGHT => 0,
  LEFT => 1,
  DOWN => 1,
  UP => 0,
}

FACES_MAP = <<~MAP.freeze
 12
 3
45
6
MAP
MAP_MULTIPLIER = 50

PART1RULES = {
  [1, UP] => [5, UP],
  [4, UP] => [6, UP],
  [2, UP] => [2, UP],
  [5, DOWN] => [1, DOWN],
  [6, DOWN] => [4, DOWN],
  [2, DOWN] => [2, DOWN],
  [2, RIGHT] => [1, RIGHT],
  [3, RIGHT] => [3, RIGHT],
  [5, RIGHT] => [4, RIGHT],
  [6, RIGHT] => [6, RIGHT],
  [1, LEFT] => [2, LEFT],
  [3, LEFT] => [3, LEFT],
  [4, LEFT] => [5, LEFT],
  [6, LEFT] => [6, LEFT],
}.freeze

PART2RULES = {
  [1, UP] => [6, RIGHT],
  [4, UP] => [3, RIGHT],
  [2, UP] => [6, UP],
  [5, DOWN] => [6, LEFT],
  [6, DOWN] => [2, DOWN],
  [2, DOWN] => [3, LEFT],
  [2, RIGHT] => [5, LEFT],
  [3, RIGHT] => [2, UP],
  [5, RIGHT] => [2, LEFT],
  [6, RIGHT] => [5, UP],
  [1, LEFT] => [4, RIGHT],
  [3, LEFT] => [4, DOWN],
  [4, LEFT] => [1, RIGHT],
  [6, LEFT] => [1, DOWN],
}.freeze

class Day22
  include Memoized

  def part1
    map, instructions = get_input

    direction = Vector[1, 0]
    position = Vector[map[0].index(/[.#]/), 0]

    instructions.each do |instruction|
      case instruction
      when 'R'
        direction = Vector[-direction[1], direction[0]]
      when 'L'
        direction = Vector[direction[1], -direction[0]]
      when /\d+/
        instruction.to_i.times do
          next_pos, next_direction = next_position(position, direction, map, true)
          break if next_pos == position
          position = next_pos
          direction = next_direction
        end
      end
    end

    get_answer(direction, position)
  end

  def part2
    map, instructions = get_input

    direction = Vector[1, 0]
    position = Vector[map[0].index(/[.#]/), 0]

    instructions.each do |instruction|
      case instruction
      when 'R'
        direction = Vector[-direction[1], direction[0]]
      when 'L'
        direction = Vector[direction[1], -direction[0]]
      when /\d+/
        instruction.to_i.times do
          next_pos, next_direction = next_position(position, direction, map, false)
          break if next_pos == position
          position = next_pos
          direction = next_direction
        end
      end
    end

    get_answer(direction, position)
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
    if @test || @test_input
      @faces_map = <<~MAP
        1
      234
        56
      MAP
      @map_multiplier = 4
      @part_1_rules = {
        [1, UP] => [5, UP],
        [2, UP] => [2, UP],
        [3, UP] => [3, UP],
        [6, UP] => [6, UP],
        [1, RIGHT] => [1, RIGHT],
        [4, RIGHT] => [2, RIGHT],
        [6, RIGHT] => [5, RIGHT],
        [5, DOWN] => [1, DOWN],
        [2, DOWN] => [2, DOWN],
        [3, DOWN] => [3, DOWN],
        [6, DOWN] => [6, DOWN],
        [1, LEFT] => [1, LEFT],
        [2, LEFT] => [4, LEFT],
        [5, LEFT] => [6, LEFT],
      }
      @part_2_rules = {
        [1, UP] => [2, DOWN],
        [2, UP] => [1, DOWN],
        [3, UP] => [1, RIGHT],
        [6, UP] => [4, LEFT],
        [1, RIGHT] => [6, LEFT],
        [4, RIGHT] => [6, DOWN],
        [6, RIGHT] => [1, LEFT],
        [5, DOWN] => [2, UP],
        [2, DOWN] => [5, UP],
        [3, DOWN] => [5, RIGHT],
        [6, DOWN] => [2, RIGHT],
        [1, LEFT] => [3, DOWN],
        [2, LEFT] => [6, UP],
        [5, LEFT] => [3, UP],
      }
    else
      @faces_map = FACES_MAP
      @map_multiplier = MAP_MULTIPLIER
      @part_1_rules = PART1RULES
      @part_2_rules = PART2RULES
    end
    @faces_map = @faces_map.split("\n")
    @faces_reverse = {}
    @faces_map.each_with_index do |line, row_index|
      line.chars.each_with_index do |char, column_index|
        if char.match?(/\d/)
          @faces_reverse[char.to_i] = Vector[column_index, row_index]
        end
      end
    end

  end

  private

  def get_answer(direction, position)
    answer = position[1] * 1000 + position[0] * 4 + 1004
    answer += case direction
    when RIGHT
      0
    when DOWN
      1
    when LEFT
      2
    when UP
      3
    end
    answer
  end

  memoize def next_position(position, direction, map, part1)
    next_position = position + direction
    next_direction = direction
    next_space = map[next_position[1]]&.at(next_position[0])
    if [nil, ' '].include?(next_space) || next_position[0] < 0 || next_position[1] < 0
      next_position, next_direction = wrap_edges(position, direction, part1)
      next_space = map[next_position[1]][next_position[0]]
    end
    next_space == '#' ? [position, direction] : [next_position, next_direction]
  end

  memoize def wrap_edges(position, direction, part1)
    map_position = position / @map_multiplier
    map_number = @faces_map[map_position[1].to_i][map_position[0].to_i].to_i
    offset = (-direction[1] * position[0] + direction[0] * position[1])
    next_face, next_direction = (part1 ? @part_1_rules : @part_2_rules)[[map_number, direction]]
    offset += -REVERSE_OFFSET[direction] + REVERSE_OFFSET[next_direction]
    next_position = @faces_reverse[next_face] * @map_multiplier
    next_position -= (@map_multiplier - 1) * next_direction if next_direction.sum == -1
    next_position_offset = Vector[(- offset * next_direction[1]) % @map_multiplier, (offset * next_direction[0]) % @map_multiplier]
    [next_position + next_position_offset, next_direction]
  end

  memoize def get_input
    map, instructions = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 22)
    end.split("\n\n")

    map = map.split("\n")
    instructions = instructions.gsub(/[LR]/) { |m| " #{m[0]} " }.split
    [map, instructions]
  end

  def get_test_input(number)
    <<~TEST
            ...#
            .#..
            #...
            ....
    ...#.......#
    ........#...
    ..#....#....
    ..........#.
            ...#....
            .....#..
            .#......
            ......#.

    10R5L5R10L4R5L5
    TEST
  end
end
if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 22'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day22.new }
    benchmark.report('Input parsing') { today.send(:get_input) }
    benchmark.report('Part 1') { part1 = today.part1 }
    benchmark.report('Part 2') { part2 = today.part2 }
  end
  puts
  puts 'Part 1:'
  puts part1
  puts
  puts 'Part 2:'
  puts part2
end

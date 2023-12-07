require_relative '../aoc_defaults'
require 'benchmark'
require 'matrix'

class Day23
  include Memoized

  def part1
    elves = get_elves
    (0..9).each do |n|
      elves = simulate_step elves, n
    end

    positions = elves.keys
    minmax_x = positions.map { |position| position[0] }.minmax
    minmax_y = positions.map { |position| position[1] }.minmax
    (minmax_x[1] - minmax_x[0] + 1) * (minmax_y[1] - minmax_y[0] + 1) - positions.count
  end

  def part2
    elves = get_elves
    loop = nil
    (0..).each do |n|
      elves = simulate_step elves, n
      if elves.all? { |_position, value| value == false }
        loop = n
        break
      end
    end

    loop + 1
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def simulate_step(elves, n)
    proposed_places = Hash.new(0)
    directions = [Vector[0, -1], Vector[0, 1], Vector[-1, 0], Vector[1, 0]]
    next_elves = {}
    proposed_moves = {}

    elves.each do |position, active|
      unless active
        next_elves[position] = false
        next
      end
      around_elves = [
        elves[position + Vector[-1, -1]],
        elves[position + Vector[0, -1]],
        elves[position + Vector[1, -1]],
        elves[position + Vector[1, 0]],
        elves[position + Vector[1, 1]],
        elves[position + Vector[0, 1]],
        elves[position + Vector[-1, 1]],
        elves[position + Vector[-1, 0]],
      ]
      if around_elves.all? { |elf| elf == nil }
        next_elves[position] = false
        next
      end

      direction = (n...n+4).find do |direction_order|
        case direction_order % 4
        when 0
          true if around_elves[0..2].all? { |elf| elf == nil }
        when 1
          true if around_elves[4..6].all? { |elf| elf == nil }
        when 2
          true if around_elves[6] == nil && around_elves[7] == nil && around_elves[0] == nil
        when 3
          true if around_elves[2..4].all? { |elf| elf == nil }
        end
      end

      unless direction
        next_elves[position] = true
        next
      end
      direction = directions[direction % 4]

      proposed_moves[position] = position + direction
      proposed_places[position + direction] += 1
    end

    elves.each do |position, _active|
      next if next_elves[position] != nil
      proposed_move = proposed_moves[position]
      if proposed_places[proposed_move] <= 1
        next_elves[proposed_move] = true
        direction = proposed_move - position
        activated_position = proposed_move + direction
        next_elves[activated_position] = true if next_elves[activated_position] == false
        perpendicular = direction.cross_product
        activated_position = proposed_move + direction + perpendicular
        next_elves[activated_position] = true if next_elves[activated_position] == false
        activated_position = proposed_move + direction - perpendicular
        next_elves[activated_position] = true if next_elves[activated_position] == false
      else
        next_elves[position] = true
      end
    end

    next_elves
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 23)
    end.split("\n")
  end

  memoize def get_elves
    elves = {}
    get_input.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if char == '#'
          elves[Vector[x, y]] = true
        end
      end
    end
    elves
  end

  def get_test_input(number)
    <<~TEST
    ....#..
    ..###.#
    #...#.#
    .#...##
    #.###..
    ##.#.##
    .#..#..
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 23'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day23.new }
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

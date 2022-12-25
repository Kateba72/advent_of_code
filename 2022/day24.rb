require_relative '../aoc_defaults'
require 'benchmark'
require 'matrix'
require_relative '../shared/priority_queue'

class Day24
  include Memoized

  memoize def part1
    find_shortest_path(@start, @target)
  end

  def part2
    first_path = part1
    second_path = find_shortest_path(@target, @start, first_path)
    find_shortest_path(@start, @target, second_path)
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
    @map, @start, @target, @map_size = get_input
  end

  private

  def find_shortest_path(start, target, start_minute=0)
    next_moves = PriorityQueue.new
    lowest_scores = {}
    next_moves << [start_minute, start_minute, start[0], start[1]]
    map_size_lcm = @map_size[0].lcm(@map_size[1])
    lowest_scores[[start[0], start[1], start_minute % map_size_lcm]] = start_minute

    loop do
      _, score_until_now, pos_x, pos_y = next_moves.pop
      if pos_x == target[0] && pos_y == target[1]
        return score_until_now
      end

      next if lowest_scores[[pos_x, pos_y, score_until_now % map_size_lcm]]&.< score_until_now

      minute = score_until_now + 1
      normalized_minute = minute % map_size_lcm

      @map.neighbors_with_indexes(pos_y, pos_x, include_self: true).each do |value, ny, nx|
        next if value == '#'
        next unless accessible?(nx, ny, normalized_minute)
        score_min_until_end = score_until_now + (target[0] - nx).abs + (target[1] - ny).abs
        unless lowest_scores[[nx, ny, normalized_minute]]&.<= minute
          next_moves << [-score_min_until_end, minute, nx, ny]
          lowest_scores[[nx, ny, normalized_minute]] = minute
        end
      end
    end
  end

  memoize def accessible?(pos_x, pos_y, minute)
    (@map[pos_y][(pos_x - minute - 1) % @map_size[0] + 1] != '>') &&
    (@map[pos_y][(pos_x + minute - 1) % @map_size[0] + 1] != '<') &&
    (@map[(pos_y - minute - 1) % @map_size[1] + 1][pos_x] != 'v') &&
    (@map[(pos_y + minute - 1) % @map_size[1] + 1][pos_x] != '^')
  end

  memoize def get_input
    lines = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 24)
    end.split("\n")
    start = Vector[lines[0].index('.'), 0]
    target = Vector[lines[-1].index('.'), lines.size - 1]
    size = Vector[lines[0].size - 2, lines.size - 2]
    [lines, start, target, size]
  end

  def get_test_input(number)
    <<~TEST
      #.######
      #>>.<^<#
      #.<..<<#
      #>v.><>#
      #<^v^^>#
      ######.#
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 24'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day24.new }
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

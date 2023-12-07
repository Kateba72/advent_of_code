require_relative '../aoc_defaults'
require 'benchmark'
require_relative '../shared/range_group'

class Day20235
  include Memoized

  def part1
    ids, rules = get_input
    ids = RangeGroup.new(*ids.map { |x| x..x })

    rules.each do |rule|
      ids = apply_map(rule, ids)
    end

    ids.min
  end

  def part2
    ids, rules = get_input
    ids = RangeGroup.new(*ids.each_slice(2).map { |x, y| x .. x + y - 1 })

    rules.each do |rule|
      ids = apply_map(rule, ids)
    end

    ids.min
  end

  def apply_map(rules, input)
    new_ranges = []
    rules.each do |rule|
      matching_ids = input.intersection(rule[1])
      new_matching_ids = matching_ids.ranges.map do |range|
        range.first + rule[0] .. range.last + rule[0]
      end
      new_ranges += new_matching_ids
    end
    RangeGroup.new(*new_ranges)
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def get_input
    seeds, *rules = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2023, 5)
    end.split("\n\n")
    seeds = seeds.split(": ")[1].split(' ').map(&:to_i)
    max_value = seeds.sum
    rules = rules.map do |rule|
      ruleparts = rule.split("\n")[1..]
      null_range = RangeGroup.new(0..max_value)
      ruleparts = ruleparts.map do |rulepart|
        dest, source, len = rulepart.split(' ').map(&:to_i)
        null_range.intersection!([0..source - 1, source + len..max_value])
        [dest - source, source .. source + len - 1]
      end
      ruleparts << [0, null_range]
      ruleparts
    end
    [seeds, rules]
  end

  def get_test_input(number)
    <<~TEST
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48

      soil-to-fertilizer map:
      0 15 37
      37 52 2
      39 0 15

      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4

      water-to-light map:
      88 18 7
      18 25 70

      light-to-temperature map:
      45 77 23
      81 45 19
      68 64 13

      temperature-to-humidity map:
      0 69 1
      1 0 69

      humidity-to-location map:
      60 56 37
      56 93 4
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 5'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20235.new }
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

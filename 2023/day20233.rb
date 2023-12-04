require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day20233
  include Memoized

  def part1
    lines = get_input.split("\n")
    symbols = lines.map do |line|
      line.enum_for(:scan, /[^.\w]/).map do
        Regexp.last_match.offset(0).first
      end
    end
    numbers = lines.map.with_index do |line, index|
      line.enum_for(:scan, /\d+/).sum do
        offset_range = (Regexp.last_match.offset(0).first - 1) .. (Regexp.last_match.offset(0).last)
        if (index > 0 && symbols[index - 1].any? { |x| offset_range.include? x }) ||
            (symbols[index].any? { |x| offset_range.include? x }) ||
            (index < lines.size - 1 && symbols[index + 1].any? { |x| offset_range.include? x})
          Regexp.last_match.to_s.to_i
        else
          0
        end
      end
    end
    numbers.sum
  end

  def part2
    lines = get_input.split("\n")
    gear_candidates = lines.map do |line|
      line.enum_for(:scan, /\*/).map do
        Regexp.last_match.offset(0).first
      end
    end
    gears = {}
    lines.map.with_index do |line, index|
      line.enum_for(:scan, /\d+/).each do
        offset_range = (Regexp.last_match.offset(0).first - 1) .. (Regexp.last_match.offset(0).last)
        value = Regexp.last_match.to_s.to_i
        if index > 0
          gear_candidates[index - 1].each do |x|
            next unless offset_range.include? x
            gears[[index - 1, x]] ||= []
            gears[[index - 1, x]] << value
          end
        end
        if index < lines.size - 1
          gear_candidates[index + 1].each do |x|
            next unless offset_range.include? x
            gears[[index + 1, x]] ||= []
            gears[[index + 1, x]] << value
          end
        end
        gear_candidates[index].each do |x|
          next unless offset_range.include? x
          gears[[index, x]] ||= []
          gears[[index, x]] << value
        end
      end
    end

    gears.sum do |_pos, gear|
      next 0 unless gear.size > 1
      gear.inject(:*)
    end
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2023, 3)
    end
  end

  def get_test_input(number)
    <<~TEST
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 3'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20233.new }
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

require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day20231
  include Memoized

  NUMBERS_WITH_LETTERS = {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9
  }

  def part1
    input = get_input

    input.sum do |line|
      first = line.match(/\d/).to_s.to_i
      last = line.reverse.match(/\d/).to_s.to_i
      first * 10 + last
    end

  end

  def part2
    input = get_input
    input.sum do |line|
      first = line.match(/(\d|one|two|three|four|five|six|seven|eight|nine)/).to_s
      first = str_to_i(first)
      last = line.reverse.match(/(\d|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno)/).to_s
      last = str_to_i(last.reverse)
      first * 10 + last
    end
  end

  def str_to_i(str)
    NUMBERS_WITH_LETTERS[str] || str.to_i
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
      get_aoc_input(2023, 1)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 1'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20231.new }
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

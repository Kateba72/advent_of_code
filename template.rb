require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day💙day💙
  include Memoized

  def part1
    input = get_input

  end

  def part2
    input = get_input
    ''
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
      get_aoc_input(💙year💙, 💙day💙)
    end
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 💙day💙'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day💙day💙.new; today.send(:get_input) }
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

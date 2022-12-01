require_relative '../aoc_defaults'
# require 'matrix'

class Day💙day💙
  include Memoized

  def part1
    input = get_input

  end

  def part2
    input = get_input

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
  today = Day💙day💙.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

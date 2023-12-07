require_relative '../aoc_defaults'
# require 'matrix'

class Day6
  include Memoized

  def part1
    input = get_input
    start_marker input, 4
  end

  def part2
    input = get_input
    start_marker input, 14
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def start_marker(input, marker_size)
    ((marker_size-1)..).find do |i|
      Set.new(input[(i-marker_size+1)..i].chars).size == marker_size
    end + 1
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 6)
    end
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today = Day6.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

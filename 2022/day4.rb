require_relative '../aoc_defaults'
# require 'matrix'

class Day4
  include Memoized

  def part1
    input = get_input
    input.count do |line|
      intersection = line[0] & line[1]
      intersection == line[0] || intersection == line[1]
    end
  end

  def part2
    input = get_input
    input.count do |line|
      intersection = line[0] & line[1]
      intersection.size > 0
    end
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def get_input
    input = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 4)
    end
    input.split("\n").map do |line|
      m = line.match(/^(\d+)-(\d+),(\d+)-(\d+)$/)
      [(m[1].to_i)..m[2].to_i, m[3].to_i..m[4].to_i]
    end
  end

  def get_test_input(number)
    <<~TEST
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    TEST
  end
end

if __FILE__ == $0
  today = Day4.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

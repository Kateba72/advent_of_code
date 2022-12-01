require_relative '../aoc_defaults'
# require 'matrix'

class Day1
  include Memoized

  def part1
    elves.max
  end

  def part2
    elves.sort.last(3).sum
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def elves
    get_input.split("\n\n").map do |elf|
      elf.split("\n").map(&:to_i).sum
    end
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 1)
    end
  end

  def get_test_input(number)
    <<~TEST
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    TEST
  end
end

if __FILE__ == $0
  today = Day1.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

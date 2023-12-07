require_relative '../aoc_defaults'
# require 'matrix'

class Day15
  include Memoized

  def part1
    nth_number(2020, get_input)
  end

  def part2
    nth_number(30000000, get_input)
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def nth_number(n, numbers)
    last_spoken = {}
    numbers.each_with_index do |number, index|
      last_spoken[number] = index
    end

    next_number = nil
    (numbers.size...n).each do |index|
      last_number = next_number
      next_number = if last_spoken[last_number]
        index - 1 - last_spoken[last_number]
      else
        0
      end
      last_spoken[last_number] = index - 1
    end

    next_number
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      [0, 3, 6]
    else
      [9,3,1,0,8,4]
    end
  end
end

if __FILE__ == $0
  today = Day15.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

require_relative '../aoc_defaults'
# require 'matrix'

class Day2
  include Memoized

  def part1
    rounds = get_input
    points = { AX: 4, BX: 1, CX: 7, AY: 8, BY: 5, CY: 2, AZ: 3, BZ: 9, CZ: 6 }
    rounds.sum do |round|
      points[round.join('').to_sym]
    end
  end

  def part2
    rounds = get_input
    points = { AX: 3, BX: 1, CX: 2, AY: 4, BY: 5, CY: 6, AZ: 8, BZ: 9, CZ: 7 }
    rounds.sum do |round|
      points[round.join('').to_sym]
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
      get_aoc_input(2022, 2)
    end.split("\n").map(&:split)
  end

  def get_test_input(number)
    <<~TEST
      A Y
      B X
      C Z
    TEST
  end
end

if __FILE__ == $0
  today = Day2.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

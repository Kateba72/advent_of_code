require 'matrix'
require_relative '../aoc_defaults'

class Day9
  include Memoized

  def part1
    steps = get_input
    visited = Set.new
    knots = [Vector[0, 0]] * 2
    visited.add(knots.last)

    steps.each do |step|
      step[1].times do
        knots = move(knots, step[0])
        visited.add(knots.last)
      end
    end

    visited.size
  end

  def part2
    steps = get_input
    visited = Set.new
    knots = [Vector[0, 0]] * 10
    visited.add(knots.last)

    steps.each do |step|
      step[1].times do
        knots = move(knots, step[0])
        visited.add(knots.last)
      end
    end

    visited.size
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def move(knots, movement)
    case movement
    when 'U'
      knots[0] += Vector[0, 1]
    when 'D'
      knots[0] += Vector[0, -1]
    when 'L'
      knots[0] += Vector[-1, 0]
    when 'R'
      knots[0] += Vector[1, 0]
    end

    (0...knots.size - 1).each do |index|
      difference = knots[index].p_norm_to_p(knots[index+1], 2)

      if difference >= 4
        knots[index+1] += (knots[index] - knots[index+1]).map do |element|
          if element >= 1
            1
          elsif element <= -1
            -1
          else
            element
          end
        end
      end
    end

    knots
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 9)
    end.split("\n").map do |line|
      [line[0], line[2..].to_i]
    end
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today = Day9.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end

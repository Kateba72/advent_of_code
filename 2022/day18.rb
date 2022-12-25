require_relative '../aoc_defaults'
require 'benchmark'
require 'matrix'

class Day18
  include Memoized

  def part1
    input = get_input
    input_set = Set.new(input)

    input.sum do |point|
      [
        point + Vector[1, 0, 0],
        point + Vector[-1, 0, 0],
        point + Vector[0, 1, 0],
        point + Vector[0, -1, 0],
        point + Vector[0, 0, 1],
        point + Vector[0, 0, -1],
      ].count do |other_point|
        input_set.exclude? other_point
      end
    end
  end

  def part2
    points = get_input
    points_set = Set.new(points)
    mx = points.map { |point| point[0] }.max + 2
    my = points.map { |point| point[1] }.max + 2
    mz = points.map { |point| point[2] }.max + 2
    matrix = (0..mx).map do |x|
      (0..my).map do |y|
        [0] * (mz + 1)
      end
    end

    points.each do |point|
      matrix[point[0] + 1][point[1] + 1][point[2] + 1] = 1
    end

    matrix[0][0][0] = 2
    queue = [Vector[0, 0, 0]]

    while queue.present?
      point = queue.pop
      [
        point + Vector[1, 0, 0],
        point + Vector[-1, 0, 0],
        point + Vector[0, 1, 0],
        point + Vector[0, -1, 0],
        point + Vector[0, 0, 1],
        point + Vector[0, 0, -1],
      ].each do |other_point|
        next if other_point[0] < 0 || other_point[0] > mx || other_point[1] < 0 || other_point[1] > my || other_point[2] < 0 || other_point[2] > mz
        next if matrix[other_point[0]][other_point[1]][other_point[2]] != 0
        next if queue.include? other_point
        matrix[other_point[0]][other_point[1]][other_point[2]] = points_set.include?(other_point + Vector[-1, -1, -1]) ? 1 : 2
        queue.append(other_point)
      end
    end

    points.sum do |point|
      [
        point + Vector[1, 0, 0],
        point + Vector[-1, 0, 0],
        point + Vector[0, 1, 0],
        point + Vector[0, -1, 0],
        point + Vector[0, 0, 1],
        point + Vector[0, 0, -1],
      ].count do |other_point|
        matrix[other_point[0] + 1][other_point[1] + 1][other_point[2] + 1] == 2
      end
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
      get_aoc_input(2022, 18)
    end.split("\n").map do |line|
      Vector[*(line.split(',').map &:to_i)]
    end
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 18'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day18.new; today.send(:get_input) }
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

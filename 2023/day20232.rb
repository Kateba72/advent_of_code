require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day20232
  include Memoized

  def part1
    input = get_input
    input.sum do |line|
      game_info, infos = line.split(': ')
      game_no = game_info.split(' ')[1].to_i
      infos.split(/[,;] /).all? do |info|
        count, color = info.split(' ')
        count = count.to_i
        (color == 'red' && count <= 12) || (color == 'green' && count <= 13) || (color == 'blue' && count <= 14)
      end ? game_no : 0
    end
  end

  def part2
    input = get_input
    input.sum do |line|
      _game_info, infos = line.split(':')
      %w[red green blue].map do |color|
        infos.scan(/ (\d+) #{color}/).map { |m| m[0].to_i}.max
      end.inject(:*)
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
      get_aoc_input(2023, 2)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 2'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20232.new }
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

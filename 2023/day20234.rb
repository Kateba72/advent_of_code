require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day20234
  include Memoized

  def part1
    input = get_input
    input.sum do |line|
      _cardno, numbers = line.split(': ')
      winning, having = numbers.split(' | ').map { |n| Set.new(n.split(' ')) }
      winning_size = (winning & having).size
      winning_size > 0 ? 2 ** (winning_size - 1) : 0
    end
  end

  def part2
    input = get_input
    extra_copies = {}
    input.sum do |line|
      cardno, numbers = line.split(': ')
      cardno = cardno.split(' ')[1].to_i
      winning, having = numbers.split(' | ').map { |n| Set.new(n.split(' ')) }
      winning_size = (winning & having).size
      these_copies = extra_copies[cardno] || 1
      if winning_size > 0
        ((cardno + 1)..(cardno + winning_size)).each do |win|
          extra_copies[win] ||= 1
          extra_copies[win] += these_copies
        end
      end
      these_copies
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
      get_aoc_input(2023, 4)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 4'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20234.new }
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

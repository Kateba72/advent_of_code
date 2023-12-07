require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day20237
  include Memoized

  CARD_ORDER_PART_1 = %w[A K Q J T 9 8 7 6 5 4 3 2]
  CARD_ORDER_PART_2 = %w[A K Q T 9 8 7 6 5 4 3 2 J]

  def part1
    input = get_input
    hands = input.map do |line|
      cards, bid = line.split(' ')
      [cards.chars.map { |c| CARD_ORDER_PART_1.index(c) }, bid.to_i]
    end

    sorted_hands = hands.sort_by do |hand|
      kind = hand[0].map { |card| hand[0].count(card) }.sort.reverse
      [kind, hand[0].map {|c| -c }]
    end

    sorted_hands.map.with_index do |hand, index|
      hand[1] * (index + 1)
    end.sum
  end

  def part2
    input = get_input
    hands = input.map do |line|
      cards, bid = line.split(' ')
      [cards.chars.map { |c| CARD_ORDER_PART_2.index(c) }, bid.to_i]
    end

    sorted_hands = hands.sort_by do |hand|
      best_card = (0..11).max_by { |c| hand[0].count(c) }
      kind = hand[0].map do |card|
        if card == 12 || card == best_card
          hand[0].count(12) + hand[0].count(best_card)
        else
          hand[0].count(card)
        end
      end.sort.reverse
      [kind, hand[0].map {|c| -c }]
    end

    sorted_hands.map.with_index do |hand, index|
      hand[1] * (index + 1)
    end.sum
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
      get_aoc_input(2023, 7)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 7'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20237.new }
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

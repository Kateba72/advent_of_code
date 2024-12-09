require_relative '../solution'

module AoC
  module Y2023
    class D07 < Solution

      CARD_ORDER_PART_1 = %w[A K Q J T 9 8 7 6 5 4 3 2].freeze
      CARD_ORDER_PART_2 = %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze

      def part1
        input = parse_input
        hands = input.map do |line|
          cards, bid = line.split
          [cards.chars.map { |c| CARD_ORDER_PART_1.index(c) }, bid.to_i]
        end

        sorted_hands = hands.sort_by do |hand|
          kind = hand[0].map { |card| hand[0].count(card) }.sort.reverse
          [kind, hand[0].map(&:-@)]
        end

        sorted_hands.map.with_index do |hand, index|
          hand[1] * (index + 1)
        end.sum
      end

      def part2
        input = parse_input
        hands = input.map do |line|
          cards, bid = line.split
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
          [kind, hand[0].map(&:-@)]
        end

        sorted_hands.map.with_index do |hand, index|
          hand[1] * (index + 1)
        end.sum
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          32T3K 765
          T55J5 684
          KK677 28
          KTJJT 220
          QQQJA 483
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 7
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D07.new(test: false)
  today.run
end

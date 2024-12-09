require_relative '../solution'

module AoC
  module Y2023
    class D04 < Solution

      def part1
        input = parse_input
        input.sum do |line|
          _cardno, numbers = line.split(': ')
          winning, having = numbers.split(' | ').map { |n| Set.new(n.split) }
          winning_size = (winning & having).size
          winning_size > 0 ? 2**(winning_size - 1) : 0
        end
      end

      def part2
        input = parse_input
        extra_copies = {}
        input.sum do |line|
          cardno, numbers = line.split(': ')
          cardno = cardno.split[1].to_i
          winning, having = numbers.split(' | ').map { |n| Set.new(n.split) }
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

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
          Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
          Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
          Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
          Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
          Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 4
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D04.new(test: false)
  today.run
end

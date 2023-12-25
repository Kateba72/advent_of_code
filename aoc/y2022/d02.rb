require_relative '../solution'

module AoC
  module Y2022
    class D02 < Solution

      def part1
        rounds = parse_input
        points = { AX: 4, BX: 1, CX: 7, AY: 8, BY: 5, CY: 2, AZ: 3, BZ: 9, CZ: 6 }
        rounds.sum do |round|
          points[round.join('').to_sym]
        end
      end

      def part2
        rounds = parse_input
        points = { AX: 3, BX: 1, CX: 2, AY: 4, BY: 5, CY: 6, AZ: 8, BZ: 9, CZ: 7 }
        rounds.sum do |round|
          points[round.join('').to_sym]
        end
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:split)
      end

      def get_test_input(number)
        <<~TEST
          A Y
          B X
          C Z
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 2
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D02.new(test: false)
  today.run
end

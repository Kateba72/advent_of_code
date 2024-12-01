require_relative '../solution'

module AoC
  module Y2021
    class D07 < Solution

      def part1
        input = parse_input.sort
        optimal_position = input[(input.size / 2).to_i]

        input.sum { (_1 - optimal_position).abs }
      end

      def part2
        input = parse_input
        optimal_position = (input.sum / input.size).round

        input.sum do
          distance = (_1 - optimal_position).abs
          distance * (distance + 1) / 2
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split(",").map(&:to_i)
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 7
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D07.new(test: false)
  today.run
end

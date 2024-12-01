require_relative '../solution'

module AoC
  module Y2021
    class D06 < Solution

      def part1
        solve(80)
      end

      def part2
        solve(256)
      end

      def solve(days)
        input = parse_input
        state = (0..8).map { input.count(_1) }

        days.times do
          zeros = state.shift
          state[8] = zeros
          state[6] += zeros
        end

        state.sum
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
      AOC_DAY = 6
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D06.new(test: false)
  today.run
end
